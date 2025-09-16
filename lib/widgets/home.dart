import 'package:flutter/material.dart';

void main() {
  runApp(HomeScreens());
}

class HomeScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarSiswaDigitalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DaftarSiswaDigitalPage extends StatefulWidget {
  @override
  State<DaftarSiswaDigitalPage> createState() =>
      _DaftarSiswaDigitalPageState();
}

class _DaftarSiswaDigitalPageState extends State<DaftarSiswaDigitalPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  String? _selectedReligion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: Icon(Icons.note_add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header AppBar Nyatu ke atas
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Text(
                  "Daftar Siswa Digital",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Logo
            Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade300, width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Selamat Datang di\nInput Data Digital\nSMK Negeri Swasta Jakawarna",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 20),

            Text("Formulir Data Siswa",
                style: TextStyle(color: Colors.black54, fontSize: 14)),

            SizedBox(height: 20),

            // Form Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField("NISN"),
                    buildTextField("Nama Lengkap"),

                    // Dropdown Gender
                    buildDropdownField(
                      "Jenis Kelamin",
                      ["Laki-laki", "Perempuan"],
                      _selectedGender,
                      (val) => setState(() => _selectedGender = val),
                    ),

                    // Dropdown Agama
                    buildDropdownField(
                      "Agama",
                      ["Islam", "Kristen", "Katolik", "Hindu", "Budha", "Konghucu"],
                      _selectedReligion,
                      (val) => setState(() => _selectedReligion = val),
                    ),

                    buildTextField("Tempat, Tanggal Lahir"),
                    buildTextField("No. Tlp/HP"),
                    buildTextField("NIK"),

                    SizedBox(height: 20),

                    // Alamat
                    buildSectionCard("Alamat", [
                      buildTextField("Jalan"),
                      buildTextField("RT/RW"),
                      buildTextField("Dusun"),
                      buildTextField("Desa"),
                      buildTextField("Kecamatan"),
                      buildTextField("Kabupaten"),
                      buildTextField("Provinsi"),
                      buildTextField("Kode Pos"),
                    ]),

                    SizedBox(height: 20),

                    // Orang Tua
                    buildSectionCard("Orang Tua / Wali", [
                      buildTextField("Nama Ayah"),
                      buildTextField("Nama Ibu"),
                      buildTextField("Nama Wali"),
                      buildTextField("Alamat Orang Tua/Wali"),
                    ]),

                    SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Data berhasil disimpan")),
                          );
                        }
                      },
                      child: Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input Minimalis
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 1.5),
          ),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
      ),
    );
  }

  /// Dropdown Minimalis
  Widget buildDropdownField(
      String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            border: InputBorder.none,
          ),
          icon: Icon(Icons.arrow_drop_down, color: Colors.orange),
          style: TextStyle(color: Colors.black, fontSize: 14),
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: (value) =>
              (value == null || value.isEmpty) ? "$label tidak boleh kosong" : null,
        ),
      ),
    );
  }

  /// Section Card
  Widget buildSectionCard(String title, List<Widget> fields) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 12),
            ...fields,
          ],
        ),
      ),
    );
  }
}
