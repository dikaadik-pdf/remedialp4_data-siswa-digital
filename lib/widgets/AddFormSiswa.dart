import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class DaftarSiswaDigitalPage extends StatefulWidget {
  const DaftarSiswaDigitalPage({super.key});

  @override
  State<DaftarSiswaDigitalPage> createState() =>
      _DaftarSiswaDigitalPageState();
}

class _DaftarSiswaDigitalPageState extends State<DaftarSiswaDigitalPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown
  String? _selectedGender;
  String? _selectedReligion;

  // Tanggal & tempat lahir
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();

  // Data utama
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  // Alamat
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _dusunController = TextEditingController();
  final TextEditingController _desaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();

  // Orang tua / wali
  final TextEditingController _namaAyahController = TextEditingController();
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaWaliController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();

  // 🔹 Data dusun dari Supabase
  List<Map<String, dynamic>> _dusunList = [];

  @override
  void initState() {
    super.initState();
    _loadDusun();
  }

  Future<void> _loadDusun() async {
    try {
      final response = await Supabase.instance.client.from('dusun').select();
      setState(() {
        _dusunList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal load dusun: $e")),
      );
    }
  }

  // ✅ Reusable input formatter sesuai DB
  List<TextInputFormatter> onlyNumber(int max) => [
        LengthLimitingTextInputFormatter(max),
        FilteringTextInputFormatter.digitsOnly,
      ];
  List<TextInputFormatter> onlyText(int max) =>
      [LengthLimitingTextInputFormatter(max)];

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
              // Header modern
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
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

              // Form Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
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
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 16),

                          // Data Utama
                          buildTextField("NISN", _nisnController,
                              formatters: onlyNumber(10)),
                          buildTextField("Nama Lengkap", _namaController,
                              formatters: onlyText(35)),

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

                          // Tempat & Tanggal Lahir
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _tempatLahirController,
                                    inputFormatters: onlyText(15),
                                    decoration:
                                        inputDecoration("Tempat Lahir"),
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

                          buildTextField("No. Tlp/HP", _noHpController,
                              formatters: onlyNumber(15)),
                          buildTextField("NIK", _nikController,
                              formatters: onlyNumber(16)),

                          // Alamat
                          buildSectionCard("Alamat", [
                            buildTextField("Jalan", _jalanController),
                            buildTextField("RT/RW", _rtRwController,
                                formatters: onlyNumber(3)),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return _dusunList
                                    .map((item) => item['nama'] as String)
                                    .where((dusun) => dusun
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()));
                              },
                              onSelected: (String selection) {
                                _dusunController.text = selection;
                              },
                              fieldViewBuilder: (context, controller,
                                  focusNode, onEditingComplete) {
                                controller.text = _dusunController.text;
                                controller.addListener(() {
                                  _dusunController.text = controller.text;
                                });

                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  inputFormatters: onlyText(50),
                                  decoration: inputDecoration("Dusun"),
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                          ? "Dusun tidak boleh kosong"
                                          : null,
                                );
                              },
                            ),
                            buildTextField("Desa", _desaController,
                                formatters: onlyText(50)),
                            buildTextField("Kecamatan", _kecamatanController,
                                formatters: onlyText(50)),
                            buildTextField("Kabupaten", _kabupatenController,
                                formatters: onlyText(50)),
                            buildTextField("Provinsi", _provinsiController,
                                formatters: onlyText(50)),
                            buildTextField("Kode Pos", _kodePosController,
                                formatters: onlyNumber(5)),
                          ]),

                          // Orang Tua / Wali
                          buildSectionCard("Orang Tua / Wali", [
                            buildTextField("Nama Ayah", _namaAyahController,
                                formatters: onlyText(35)),
                            buildTextField("Nama Ibu", _namaIbuController,
                                formatters: onlyText(35)),
                            buildTextField("Nama Wali", _namaWaliController,
                                formatters: onlyText(35)),
                            buildTextField("Alamat Orang Tua/Wali",
                                _alamatOrtuController),
                          ]),

                          const SizedBox(height: 30),

                          // Tombol Simpan
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
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

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Data berhasil disimpan')));
                                    _formKey.currentState!.reset();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Simpan",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
  // === STYLE BARU ===
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {List<TextInputFormatter>? formatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        inputFormatters: formatters,
        decoration: inputDecoration(label),
        validator: (value) =>
            (value == null || value.isEmpty)
                ? "$label tidak boleh kosong"
                : null,
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
            (value == null || value.isEmpty)
                ? "$label tidak boleh kosong"
                : null,
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
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.deepOrange)),
            const SizedBox(height: 10),
            ...fields,
          ],
        ),
      ),
    );
  }
}
