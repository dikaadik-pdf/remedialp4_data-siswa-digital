import 'package:flutter/material.dart';
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
  State<DaftarSiswaDigitalPage> createState() => _DaftarSiswaDigitalPageState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  "Daftar Siswa Digital",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Selamat Datang di\nInput Data Digital\nSMK Negeri Swasta Jakawarna",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 12),

              const Text(
                "Formulir Data Siswa",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("NISN", _nisnController),
                      buildTextField("Nama Lengkap", _namaController),

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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _tempatLahirController,
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
                                decoration: inputDecoration("Tanggal Lahir").copyWith(
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.orange,
                                  ),
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
                                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
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

                      buildTextField("No. Tlp/HP", _noHpController),
                      buildTextField("NIK", _nikController),

                      // Alamat
                      buildSectionCard("Alamat", [
                        buildTextField("Jalan", _jalanController),
                        buildTextField("RT/RW", _rtRwController),
                        buildTextField("Dusun", _dusunController),
                        buildTextField("Desa", _desaController),
                        buildTextField("Kecamatan", _kecamatanController),
                        buildTextField("Kabupaten", _kabupatenController),
                        buildTextField("Provinsi", _provinsiController),
                        buildTextField("Kode Pos", _kodePosController),
                      ]),

                      // Orang Tua / Wali
                      buildSectionCard("Orang Tua / Wali", [
                        buildTextField("Nama Ayah", _namaAyahController),
                        buildTextField("Nama Ibu", _namaIbuController),
                        buildTextField("Nama Wali", _namaWaliController),
                        buildTextField("Alamat Orang Tua/Wali", _alamatOrtuController),
                      ]),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await Supabase.instance.client
                                  .from('siswa')
                                  .insert({
                                'nisn': _nisnController.text,
                                'nama_lengkap': _namaController.text,
                                'jenis_kelamin': _selectedGender,
                                'agama': _selectedReligion,
                                'tempat_lahir': _tempatLahirController.text,
                                'tanggal_lahir': _tanggalLahirController.text,
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
                                'alamat_orang_tua_wali': _alamatOrtuController.text,
                              });

                              if (response.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal simpan: ${response.error!.message}')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Data berhasil disimpan')),
                                );
                                _formKey.currentState!.reset();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orange, width: 1.5),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: inputDecoration(label),
        validator: (value) => (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
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
        icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
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
        validator: (value) => (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
      ),
    );
  }

  Widget buildSectionCard(String title, List<Widget> fields) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            ...fields,
          ],
        ),
      ),
    );
  }
}
