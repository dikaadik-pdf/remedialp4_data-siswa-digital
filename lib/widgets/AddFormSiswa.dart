import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ----------------------
// Helper: RT/RW Formatter
class RtRwInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    // Batasi total digit menjadi maksimal 4 (RT dan RW masing-masing hingga 2 digit)
    if (digits.length > 4) {
      return oldValue; // Tidak mengizinkan lebih dari 4 digit
    }

    String formatted = '';
    if (digits.length <= 2) {
      formatted = digits.padLeft(2, '0');
    } else {
      // Pisahkan menjadi RT dan RW, maksimal 2 digit per bagian
      String rt = digits.substring(0, 2).padLeft(2, '0');
      String rw = digits.length > 2 ? digits.substring(2, digits.length <= 4 ? digits.length : 4).padLeft(2, '0') : '20';
      formatted = '$rt/$rw';
    }

    // Pastikan total panjang (termasuk "/") tidak melebihi 5 karakter
    if (formatted.length > 5) {
      formatted = formatted.substring(0, 5); // Potong jika melebihi 5 karakter
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ----------------------
// Main + Supabase init
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qrpwmbohdxzqkcbybvue.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFycHdtYm9oZHh6cWtjYnlidnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTAxMzEsImV4cCI6MjA3MzU2NjEzMX0.Yc46cV6EKSigAvjSyoWscTrC6LkHA-A84mjWdZOnuyA',
  );
  runApp(const HomeScreens());
}

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DaftarSiswaDigitalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------
// Halaman Form
class DaftarSiswaDigitalPage extends StatefulWidget {
  const DaftarSiswaDigitalPage({super.key});

  @override
  State<DaftarSiswaDigitalPage> createState() => _DaftarSiswaDigitalPageState();
}

class _DaftarSiswaDigitalPageState extends State<DaftarSiswaDigitalPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  String? _selectedReligion;

  // controllers siswa
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  // alamat
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _dusunController = TextEditingController();
  final TextEditingController _desaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();

  // orang tua / wali
  final TextEditingController _namaAyahController = TextEditingController();
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaWaliController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();

  // list locations (diambil dari tabel locations)
  List<Map<String, dynamic>> _locationsList = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void dispose() {
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _nisnController.dispose();
    _namaController.dispose();
    _noHpController.dispose();
    _nikController.dispose();
    _jalanController.dispose();
    _rtRwController.dispose();
    _dusunController.dispose();
    _desaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _kodePosController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaWaliController.dispose();
    _alamatOrtuController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak ada koneksi internet. Silakan cek koneksi Anda."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final response = await Supabase.instance.client.from('locations').select();
      setState(() {
        _locationsList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data lokasi dari Supabase: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // formatter helpers
  List<TextInputFormatter> onlyNumber(int max) => [
        LengthLimitingTextInputFormatter(max),
        FilteringTextInputFormatter.digitsOnly,
      ];

  List<TextInputFormatter> onlyText(int max) => [
        LengthLimitingTextInputFormatter(max),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Input Data Siswa Digital",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "SMK Negeri Swasta Jakawarna",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(225, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Formulir Data Siswa",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // fields utama
                          buildTextField(
                            "NISN",
                            _nisnController,
                            keyboardType: TextInputType.number,
                            inputFormatters: onlyNumber(10),
                          ),
                          buildTextField(
                            "Nama Lengkap",
                            _namaController,
                            keyboardType: TextInputType.text,
                            inputFormatters: onlyText(35),
                          ),

                          buildDropdownField(
                            "Jenis Kelamin",
                            ["Laki-laki", "Perempuan", "Lainnya"],
                            _selectedGender,
                            (val) => setState(() => _selectedGender = val),
                          ),

                          buildDropdownField(
                            "Agama",
                            [
                              "Islam",
                              "Kristen",
                              "Katolik",
                              "Hindu",
                              "Buddha",
                              "Konghucu",
                              "Lainnya",
                            ],
                            _selectedReligion,
                            (val) => setState(() => _selectedReligion = val),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _tempatLahirController,
                                    inputFormatters: onlyText(15),
                                    decoration: inputDecoration("Tempat Lahir"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Tempat lahir tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _tanggalLahirController,
                                    readOnly: true,
                                    decoration: inputDecoration("Tanggal Lahir")
                                        .copyWith(
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _tanggalLahirController.text =
                                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Tanggal lahir tidak boleh kosong";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          buildTextField(
                            "No. Tlp/HP",
                            _noHpController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: onlyNumber(15),
                          ),
                          buildTextField(
                            "NIK",
                            _nikController,
                            keyboardType: TextInputType.number,
                            inputFormatters: onlyNumber(16),
                          ),

                          // Section alamat
                          buildSectionCard("Alamat", [
                            buildTextField("Jalan", _jalanController),
                            buildTextField(
                              "RT/RW",
                              _rtRwController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [RtRwInputFormatter()],
                            ),
                            // Autocomplete Dusun (menggunakan data _locationsList)
                            // Saat user memilih, otomatis isi desa/kecamatan/dst
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return _locationsList
                                    .map((item) => (item['dusun'] ?? '') as String)
                                    .where((dusun) => dusun
                                        .toLowerCase()
                                        .contains(textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String selection) {
                                _dusunController.text = selection;

                                final Map<String, dynamic> selectedLocation =
                                    _locationsList.firstWhere(
                                  (item) => (item['dusun'] ?? '') == selection,
                                  orElse: () => <String, dynamic>{},
                                );

                                if (selectedLocation.isNotEmpty) {
                                  setState(() {
                                    _desaController.text =
                                        selectedLocation['desa'] ?? '';
                                    _kecamatanController.text =
                                        selectedLocation['kecamatan'] ?? '';
                                    _kabupatenController.text =
                                        selectedLocation['kabupaten'] ?? '';
                                    _provinsiController.text =
                                        selectedLocation['provinsi'] ?? '';
                                    _kodePosController.text =
                                        (selectedLocation['kode_pos'] ?? '')
                                            .toString();
                                  });
                                }
                              },
                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                final list = options.toList();
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          final option = list[index];
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              child: Text(option,
                                                  style:
                                                      const TextStyle(fontSize: 14)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (
                                context,
                                textEditingController,
                                focusNode,
                                onEditingComplete,
                              ) {
                                // sinkron ke controller internal
                                textEditingController.text =
                                    _dusunController.text;
                                textEditingController.addListener(() {
                                  _dusunController.text =
                                      textEditingController.text;
                                });

                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: inputDecoration("Dusun"),
                                  validator: (value) => (value == null || value.isEmpty)
                                      ? "Dusun tidak boleh kosong"
                                      : null,
                                );
                              },
                            ),
                            buildTextField("Desa", _desaController,
                                inputFormatters: onlyText(50)),
                            buildTextField("Kecamatan", _kecamatanController,
                                inputFormatters: onlyText(50)),
                            buildTextField("Kabupaten", _kabupatenController,
                                inputFormatters: onlyText(50)),
                            buildTextField("Provinsi", _provinsiController,
                                inputFormatters: onlyText(50)),
                            buildTextField("Kode Pos", _kodePosController,
                                keyboardType: TextInputType.number,
                                inputFormatters: onlyNumber(5)),
                          ]),

                          // Section orang tua / wali
                          buildSectionCard("Orang Tua / Wali", [
                            buildTextField("Nama Ayah", _namaAyahController,
                                inputFormatters: onlyText(35)),
                            buildTextField("Nama Ibu", _namaIbuController,
                                inputFormatters: onlyText(35)),
                            buildTextField("Nama Wali", _namaWaliController,
                                inputFormatters: onlyText(35)),
                            buildTextField(
                                "Alamat Orang Tua/Wali", _alamatOrtuController),
                          ]),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var connectivityResult =
                                      await (Connectivity().checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Tidak ada koneksi internet. Silakan cek koneksi Anda.",
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                    return;
                                  }

                                  try {
                                    await Supabase.instance.client
                                        .from('siswa')
                                        .insert({
                                      'nisn': _nisnController.text,
                                      'nama_lengkap': _namaController.text,
                                      'jenis_kelamin': _selectedGender,
                                      'agama': _selectedReligion,
                                      'tempat_lahir':
                                          _tempatLahirController.text,
                                      'tanggal_lahir':
                                          _tanggalLahirController.text,
                                      'no_tlp': _noHpController.text,
                                      'nik': _nikController.text,
                                      'jalan': _jalanController.text,
                                      'rt_rw': _rtRwController.text,
                                      'dusun': _dusunController.text,
                                      'desa': _desaController.text,
                                      'kecamatan': _kecamatanController.text,
                                      'kabupaten': _kabupatenController.text,
                                      'provinsi': _provinsiController.text,
                                      'kode_pos': _kodePosController.text,
                                      'nama_ayah': _namaAyahController.text,
                                      'nama_ibu': _namaIbuController.text,
                                      'nama_wali': _namaWaliController.text,
                                      'alamat_orang_tua_wali':
                                          _alamatOrtuController.text,
                                    });

                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Data berhasil disimpan'),
                                        backgroundColor: Colors.green,
                                      ));
                                    }

                                    _formKey.currentState!.reset();
                                    // kosongkan controllers juga jika butuh:
                                    _nisnController.clear();
                                    _namaController.clear();
                                    _selectedGender = null;
                                    _selectedReligion = null;
                                    _tempatLahirController.clear();
                                    _tanggalLahirController.clear();
                                    _noHpController.clear();
                                    _nikController.clear();
                                    _jalanController.clear();
                                    _rtRwController.clear();
                                    _dusunController.clear();
                                    _desaController.clear();
                                    _kecamatanController.clear();
                                    _kabupatenController.clear();
                                    _provinsiController.clear();
                                    _kodePosController.clear();
                                    _namaAyahController.clear();
                                    _namaIbuController.clear();
                                    _namaWaliController.clear();
                                    _alamatOrtuController.clear();

                                    setState(() {}); // refresh UI
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Error saat menyimpan data ke Supabase: $e'),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                "Simpan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------
  // Helper UI functions
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(
          color: Colors.deepOrange, fontWeight: FontWeight.bold),
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 16),
        decoration: inputDecoration(label),
        validator: (val) =>
            val == null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: inputDecoration(label),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        isExpanded: true,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
            (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
      ),
    );
  }

  Widget buildSectionCard(String title, List<Widget> fields) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 10),
            ...fields,
          ],
        ),
      ),
    );
  }
}