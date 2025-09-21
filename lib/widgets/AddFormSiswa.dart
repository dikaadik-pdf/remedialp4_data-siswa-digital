import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// =================== RT/RW INPUT FORMATTER ===================
class RtRwInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    
    if (digits.length > 4) return oldValue;
    
    String formatted = '';
    if (digits.length <= 2) {
      formatted = digits.padLeft(2, '0');
    } else {
      String rt = digits.substring(0, 2).padLeft(2, '0');
      String rw = digits.substring(2, digits.length <= 4 ? digits.length : 4).padLeft(2, '0');
      formatted = '$rt/$rw';
    }
    
    if (formatted.length > 5) formatted = formatted.substring(0, 5);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// =================== MAIN FORM CLASS ===================
class DaftarSiswaDigitalPage extends StatefulWidget {
  const DaftarSiswaDigitalPage({super.key});

  @override
  State<DaftarSiswaDigitalPage> createState() => _DaftarSiswaDigitalPageState();
}

class _DaftarSiswaDigitalPageState extends State<DaftarSiswaDigitalPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown selections
  String? _selectedGender;
  String? _selectedReligion;

  // Text Controllers - Inisialisasi dengan aman
  late final TextEditingController _tempatLahirController;
  late final TextEditingController _tanggalLahirController;
  late final TextEditingController _nisnController;
  late final TextEditingController _namaController;
  late final TextEditingController _noHpController;
  late final TextEditingController _nikController;

  // Alamat Controllers
  late final TextEditingController _jalanController;
  late final TextEditingController _rtController;
  late final TextEditingController _rwController;
  late final TextEditingController _dusunController;
  late final TextEditingController _desaController;
  late final TextEditingController _kecamatanController;
  late final TextEditingController _kabupatenController;
  late final TextEditingController _provinsiController;
  late final TextEditingController _kodePosController;

  // Orang tua / wali Controllers
  late final TextEditingController _namaAyahController;
  late final TextEditingController _namaIbuController;
  late final TextEditingController _namaWaliController;
  late final TextEditingController _alamatOrtuController;

  List<Map<String, dynamic>> _locationsList = [];

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi semua controllers
    _initializeControllers();
    
    // Validasi controllers
    _validateControllers();
    
    // Load locations untuk autocomplete
    _loadLocations();
  }

  void _initializeControllers() {
    _tempatLahirController = TextEditingController();
    _tanggalLahirController = TextEditingController();
    _nisnController = TextEditingController();
    _namaController = TextEditingController();
    _noHpController = TextEditingController();
    _nikController = TextEditingController();
    _jalanController = TextEditingController();
    _rtController = TextEditingController();
    _rwController = TextEditingController();
    _dusunController = TextEditingController();
    _desaController = TextEditingController();
    _kecamatanController = TextEditingController();
    _kabupatenController = TextEditingController();
    _provinsiController = TextEditingController();
    _kodePosController = TextEditingController();
    _namaAyahController = TextEditingController();
    _namaIbuController = TextEditingController();
    _namaWaliController = TextEditingController();
    _alamatOrtuController = TextEditingController();
  }

  void _validateControllers() {
    print("=== VALIDATING CONTROLLERS ===");
    
    final controllers = {
      'tempatLahir': _tempatLahirController,
      'tanggalLahir': _tanggalLahirController,
      'nisn': _nisnController,
      'nama': _namaController,
      'noHp': _noHpController,
      'nik': _nikController,
      'jalan': _jalanController,
      'rt': _rtController,
      'rw': _rwController,
      'dusun': _dusunController,
      'desa': _desaController,
      'kecamatan': _kecamatanController,
      'kabupaten': _kabupatenController,
      'provinsi': _provinsiController,
      'kodePos': _kodePosController,
      'namaAyah': _namaAyahController,
      'namaIbu': _namaIbuController,
      'namaWali': _namaWaliController,
      'alamatOrtu': _alamatOrtuController,
    };
    
    bool allControllersValid = true;
    controllers.forEach((name, controller) {
      if (controller == null) {
        print("ERROR: Controller $name is null!");
        allControllersValid = false;
      } else {
        print("OK: Controller $name initialized");
      }
    });
    
    print("Selected Gender: $_selectedGender");
    print("Selected Religion: $_selectedReligion");
    print("All controllers valid: $allControllersValid");
    print("===============================");
  }

  Future<void> _loadLocations() async {
    try {
      print("Loading locations...");
      final response = await Supabase.instance.client.from('locations').select();
      if (mounted) {
        setState(() {
          _locationsList = List<Map<String, dynamic>>.from(response);
        });
      }
      print("Locations loaded: ${_locationsList.length} items");
    } catch (e) {
      print("Error loading locations: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data lokasi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose semua controllers
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _nisnController.dispose();
    _namaController.dispose();
    _noHpController.dispose();
    _nikController.dispose();
    _jalanController.dispose();
    _rtController.dispose();
    _rwController.dispose();
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

  // Input formatters
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
              // Header
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
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.school, size: 60, color: Colors.deepOrange),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

                          // Fields utama
                          buildTextField("NISN", _nisnController,
                              keyboardType: TextInputType.number,
                              inputFormatters: onlyNumber(10)),
                          buildTextField("Nama Lengkap", _namaController,
                              keyboardType: TextInputType.text,
                              inputFormatters: onlyText(35)),

                          buildDropdownField("Jenis Kelamin",
                              ["Laki-laki", "Perempuan", "Lainnya"], _selectedGender,
                              (val) => setState(() => _selectedGender = val)),

                          buildDropdownField("Agama",
                              ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu", "Lainnya"],
                              _selectedReligion, (val) => setState(() => _selectedReligion = val)),

                          // Tempat & Tanggal Lahir
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _tempatLahirController,
                                    inputFormatters: onlyText(15),
                                    decoration: inputDecoration("Tempat Lahir"),
                                    validator: (value) => (value == null || value.isEmpty)
                                        ? "Tempat lahir tidak boleh kosong"
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _tanggalLahirController,
                                    readOnly: true,
                                    decoration: inputDecoration("Tanggal Lahir").copyWith(
                                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
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
                                    validator: (value) => (value == null || value.isEmpty)
                                        ? "Tanggal lahir tidak boleh kosong"
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          buildTextField("No. Tlp/HP", _noHpController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: onlyNumber(15)),
                          buildTextField("NIK", _nikController,
                              keyboardType: TextInputType.number,
                              inputFormatters: onlyNumber(16)),

                          // Section alamat dengan RT/RW terpisah
                          buildSectionCard("Alamat", [
                            buildTextField("Jalan", _jalanController),
                            
                            // RT dan RW dipisah sesuai struktur database
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _rtController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      inputFormatters: onlyNumber(3),
                                      decoration: inputDecoration("RT").copyWith(counterText: ""),
                                      validator: (val) => (val == null || val.isEmpty) ? "RT wajib diisi" : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _rwController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      inputFormatters: onlyNumber(3),
                                      decoration: inputDecoration("RW").copyWith(counterText: ""),
                                      validator: (val) => (val == null || val.isEmpty) ? "RW wajib diisi" : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Autocomplete Dusun dengan auto-fill alamat
                            buildDusunAutocomplete(),
                            
                            buildTextField("Desa", _desaController, inputFormatters: onlyText(50)),
                            buildTextField("Kecamatan", _kecamatanController, inputFormatters: onlyText(50)),
                            buildTextField("Kabupaten", _kabupatenController, inputFormatters: onlyText(50)),
                            buildTextField("Provinsi", _provinsiController, inputFormatters: onlyText(50)),
                            buildTextField("Kode Pos", _kodePosController,
                                keyboardType: TextInputType.number, inputFormatters: onlyNumber(5)),
                          ]),

                          // Section orang tua / wali
                          buildSectionCard("Orang Tua / Wali", [
                            buildTextField("Nama Ayah", _namaAyahController, inputFormatters: onlyText(35)),
                            buildTextField("Nama Ibu", _namaIbuController, inputFormatters: onlyText(35)),
                            buildTextField("Nama Wali", _namaWaliController, inputFormatters: onlyText(35)),
                            buildTextField("Alamat Orang Tua/Wali", _alamatOrtuController),
                          ]),

                          const SizedBox(height: 30),

                          // Tombol Simpan dengan error handling
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 2,
                              ),
                              onPressed: _submitForm,
                              child: const Text(
                                "Simpan",
                                style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget buildDusunAutocomplete() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          
          // Null safety untuk _locationsList
          if (_locationsList.isEmpty) {
            return const Iterable<String>.empty();
          }
          
          return _locationsList
              .map((item) => (item['dusun']?.toString() ?? ''))
              .where((dusun) => dusun.isNotEmpty && dusun
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
        },
        onSelected: (String selection) {
          _dusunController.text = selection;

          try {
            final Map<String, dynamic> selectedLocation = _locationsList.firstWhere(
              (item) => (item['dusun']?.toString() ?? '') == selection,
              orElse: () => <String, dynamic>{},
            );

            if (selectedLocation.isNotEmpty) {
              setState(() {
                _desaController.text = selectedLocation['desa']?.toString() ?? '';
                _kecamatanController.text = selectedLocation['kecamatan']?.toString() ?? '';
                _kabupatenController.text = selectedLocation['kabupaten']?.toString() ?? '';
                _provinsiController.text = selectedLocation['provinsi']?.toString() ?? '';
                _kodePosController.text = (selectedLocation['kode_pos']?.toString() ?? '');
              });
            }
          } catch (e) {
            print("Error selecting location: $e");
          }
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
          // Sinkronisasi dengan controller utama
          if (_dusunController.text != textEditingController.text) {
            textEditingController.text = _dusunController.text;
          }
          
          textEditingController.addListener(() {
            if (_dusunController.text != textEditingController.text) {
              _dusunController.text = textEditingController.text;
            }
          });

          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: inputDecoration("Dusun"),
            validator: (value) => (value == null || value.isEmpty) ? "Dusun tidak boleh kosong" : null,
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Debug: Print semua nilai sebelum submit
    print("=== DEBUG FORM VALUES ===");
    print("NISN: '${_nisnController.text}'");
    print("Nama: '${_namaController.text}'");
    print("Gender: '$_selectedGender'");
    print("Agama: '$_selectedReligion'");
    print("Tempat Lahir: '${_tempatLahirController.text}'");
    print("Tanggal Lahir: '${_tanggalLahirController.text}'");
    print("No HP: '${_noHpController.text}'");
    print("NIK: '${_nikController.text}'");
    print("Jalan: '${_jalanController.text}'");
    print("RT: '${_rtController.text}'");
    print("RW: '${_rwController.text}'");
    print("Dusun: '${_dusunController.text}'");
    print("Desa: '${_desaController.text}'");
    print("Kecamatan: '${_kecamatanController.text}'");
    print("Kabupaten: '${_kabupatenController.text}'");
    print("Provinsi: '${_provinsiController.text}'");
    print("Kode Pos: '${_kodePosController.text}'");
    print("Nama Ayah: '${_namaAyahController.text}'");
    print("Nama Ibu: '${_namaIbuController.text}'");
    print("Nama Wali: '${_namaWaliController.text}'");
    print("Alamat Ortu: '${_alamatOrtuController.text}'");
    print("========================");

    try {
      // Buat data dengan null safety
      final Map<String, dynamic> studentData = {
        'nisn': _nisnController.text.trim(),
        'nama_lengkap': _namaController.text.trim(),
        'jenis_kelamin': _selectedGender ?? '',
        'agama': _selectedReligion ?? '',
        'tempat_lahir': _tempatLahirController.text.trim(),
        'tanggal_lahir': _tanggalLahirController.text.trim(),
        'no_tlp': _noHpController.text.trim(),
        'nik': _nikController.text.trim(),
        'jalan': _jalanController.text.trim(),
        'rt': _rtController.text.trim(),
        'rw': _rwController.text.trim(),
        'dusun': _dusunController.text.trim(),
        'desa': _desaController.text.trim(),
        'kecamatan': _kecamatanController.text.trim(),
        'kabupaten': _kabupatenController.text.trim(),
        'provinsi': _provinsiController.text.trim(),
        'kode_pos': _kodePosController.text.trim(),
        'nama_ayah': _namaAyahController.text.trim(),
        'nama_ibu': _namaIbuController.text.trim(),
        'nama_wali': _namaWaliController.text.trim(),
        'alamat_orang_tua_wali': _alamatOrtuController.text.trim(),
      };

      print("Data yang akan dikirim: $studentData");

      await Supabase.instance.client.from('siswa').insert(studentData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data berhasil disimpan'),
          backgroundColor: Colors.green,
        ));
      }

      // Reset form
      _formKey.currentState!.reset();
      _clearAllControllers();
      setState(() {
        _selectedGender = null;
        _selectedReligion = null;
      });
      
    } catch (e) {
      print("Error detail: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _clearAllControllers() {
    _nisnController.clear();
    _namaController.clear();
    _tempatLahirController.clear();
    _tanggalLahirController.clear();
    _noHpController.clear();
    _nikController.clear();
    _jalanController.clear();
    _rtController.clear();
    _rwController.clear();
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
  }

  // Helper UI functions
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
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

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType,
      bool readOnly = false,
      VoidCallback? onTap,
      List<TextInputFormatter>? inputFormatters}) {
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
        validator: (val) => val == null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: inputDecoration(label),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
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