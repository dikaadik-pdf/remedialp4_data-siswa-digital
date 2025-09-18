import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Package untuk memeriksa koneksi internet

// Fungsi utama untuk inisialisasi aplikasi Flutter
// Di sini kita inisialisasi Supabase dengan URL dan Anon Key dari dashboard Supabase.
// Pastikan URL dan Anon Key sesuai dengan project Supabase Anda untuk menghubungkan ke database.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qrpwmbohdxzqkcbybvue.supabase.co', // URL Supabase dari project Anda
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFycHdtYm9oZHh6cWtjYnlidnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTAxMzEsImV4cCI6MjA3MzU2NjEzMX0.Yc46cV6EKSigAvjSyoWscTrC6LkHA-A84mjWdZOnuyA', // Anon Key Supabase dari project Anda
  );
  runApp(const HomeScreens());
}

// Widget stateless utama yang membungkus MaterialApp dan mengatur home screen ke DaftarSiswaDigitalPage.
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

// Widget stateful untuk halaman formulir pendaftaran siswa.
// Mengelola state form, controller input, dan data yang diambil dari Supabase.
class DaftarSiswaDigitalPage extends StatefulWidget {
  const DaftarSiswaDigitalPage({super.key});

  @override
  State<DaftarSiswaDigitalPage> createState() => _DaftarSiswaDigitalPageState();
}

class _DaftarSiswaDigitalPageState extends State<DaftarSiswaDigitalPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk mengelola validasi form secara keseluruhan.

  // Variabel untuk menyimpan nilai dropdown jenis kelamin dan agama.
  String? _selectedGender;
  String? _selectedReligion;

  // Controller untuk input tempat lahir dan tanggal lahir.
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();

  // Controller untuk data utama siswa seperti NISN, nama, nomor HP, dan NIK.
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  // Controller untuk alamat siswa, termasuk jalan, RT/RW, dusun, dll.
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _dusunController = TextEditingController();
  final TextEditingController _desaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();

  // Controller untuk data orang tua atau wali.
  final TextEditingController _namaAyahController = TextEditingController();
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaWaliController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();

  // List untuk menyimpan data lokasi (dusun, desa, dll.) yang diambil dari tabel 'locations' di Supabase.
  List<Map<String, dynamic>> _locationsList = [];

  // Fungsi initState: Dipanggil saat widget pertama kali dibuat.
  // Memanggil _loadLocations() untuk memuat data lokasi dari Supabase.
  @override
  void initState() {
    super.initState();
    _loadLocations(); // Load data lokasi saat aplikasi dimulai.
  }

  // Fungsi untuk memuat data lokasi dari Supabase dengan error handling.
  // Menggunakan connectivity_plus untuk cek internet, dan try-catch untuk error Supabase.
  Future<void> _loadLocations() async {
    // Cek koneksi internet sebelum mengambil data.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Error handling: Tidak ada koneksi internet.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada koneksi internet. Silakan cek koneksi Anda."),
          backgroundColor: Colors.red,
        ),
      );
      return; // Hentikan proses jika tidak ada internet.
    }

    try {
      // Ambil data dari tabel 'locations' di Supabase (sesuai SQL yang diberikan).
      final response = await Supabase.instance.client.from('locations').select();
      setState(() {
        _locationsList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      // Error handling: Masalah koneksi atau error dari Supabase.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memuat data lokasi dari Supabase: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi reusable untuk formatter input: Hanya angka dengan batas panjang maksimal.
  List<TextInputFormatter> onlyNumber(int max) => [
        LengthLimitingTextInputFormatter(max),
        FilteringTextInputFormatter.digitsOnly,
      ];

  // Fungsi reusable untuk formatter input: Hanya teks dengan batas panjang maksimal.
  List<TextInputFormatter> onlyText(int max) => [
        LengthLimitingTextInputFormatter(max),
      ];

  // Fungsi build: Membangun UI halaman, termasuk header, form, dan tombol.
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
              // Header dengan gradient background, logo, dan teks judul.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
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
                        child: Image.asset("assets/images/logo.png"), // Logo aplikasi, pastikan file ada di assets.
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

              // Kontainer form utama dibungkus dalam Card untuk tampilan lebih rapi.
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
                      key: _formKey, // Menggunakan key untuk validasi form.
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

                          // Field input untuk data utama siswa.
                          buildTextField(
                            "NISN",
                            _nisnController,
                            formatters: onlyNumber(10),
                          ),
                          buildTextField(
                            "Nama Lengkap",
                            _namaController,
                            formatters: onlyText(35),
                          ),

                          // Dropdown untuk memilih jenis kelamin.
                          buildDropdownField(
                            "Jenis Kelamin",
                            ["Laki-laki", "Perempuan", "Lainnya"],
                            _selectedGender,
                            (val) => setState(() => _selectedGender = val),
                          ),

                          // Dropdown untuk memilih agama.
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

                          // Row untuk input tempat lahir dan tanggal lahir (dengan date picker).
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
                                    readOnly: true, // Read-only, diisi via date picker.
                                    decoration: inputDecoration("Tanggal Lahir")
                                        .copyWith(
                                          suffixIcon: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.orange,
                                          ),
                                        ),
                                    onTap: () async {
                                      // Menampilkan date picker untuk memilih tanggal.
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          // Format tanggal ke YYYY-MM-DD.
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
                            formatters: onlyNumber(15),
                          ),
                          buildTextField(
                            "NIK",
                            _nikController,
                            formatters: onlyNumber(16),
                          ),

                          // Section card untuk alamat siswa.
                          buildSectionCard("Alamat", [
                            buildTextField("Jalan", _jalanController),
                            buildTextField(
                              "RT/RW",
                              _rtRwController,
                              formatters: onlyNumber(3),
                            ),
                            // Autocomplete untuk input dusun: Memberikan suggestion/auto complete berdasarkan data dari Supabase.
                            // Saat dusun dipilih, field desa, kecamatan, kabupaten, provinsi, dan kode pos terisi otomatis.
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                // Membangun list opsi suggestion berdasarkan input user (case-insensitive matching).
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return _locationsList
                                    .map((item) => item['dusun'] as String)
                                    .where(
                                      (dusun) =>
                                          dusun.toLowerCase().contains(
                                        textEditingValue.text
                                            .toLowerCase(),
                                      ),
                                    );
                              },
                              onSelected: (String selection) {
                                // Saat opsi dipilih, isi field dusun dan otomatis isi field alamat lain.
                                _dusunController.text = selection;

                                // Cari data lokasi yang sesuai dari list.
                                final selectedLocation = _locationsList.firstWhere(
                                  (item) => item['dusun'] == selection,
                                  orElse: () => {},
                                );

                                // Jika ditemukan, update state untuk mengisi field lain.
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
                                        selectedLocation['kode_pos']?.toString() ??
                                            '';
                                  });
                                }
                              },

                              // Custom builder untuk tampilan dropdown suggestion agar lebih kompak.
                              optionsViewBuilder: (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 200,
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options.elementAt(
                                            index,
                                          );
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8, // Jarak vertikal kecil untuk tampilan rapat.
                                              ),
                                              child: Text(
                                                option,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },

                              // Builder untuk field input autocomplete itu sendiri.
                              fieldViewBuilder:
                                  (
                                context,
                                controller,
                                focusNode,
                                onEditingComplete,
                              ) {
                                // Sinkronisasi controller dengan _dusunController.
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

                            // Field alamat lain yang akan terisi otomatis berdasarkan dusun.
                            buildTextField(
                              "Desa",
                              _desaController,
                              formatters: onlyText(50),
                            ),
                            buildTextField(
                              "Kecamatan",
                              _kecamatanController,
                              formatters: onlyText(50),
                            ),
                            buildTextField(
                              "Kabupaten",
                              _kabupatenController,
                              formatters: onlyText(50),
                            ),
                            buildTextField(
                              "Provinsi",
                              _provinsiController,
                              formatters: onlyText(50),
                            ),
                            buildTextField(
                              "Kode Pos",
                              _kodePosController,
                              formatters: onlyNumber(5),
                            ),
                          ]),

                          // Section card untuk data orang tua/wali.
                          buildSectionCard("Orang Tua / Wali", [
                            buildTextField(
                              "Nama Ayah",
                              _namaAyahController,
                              formatters: onlyText(35),
                            ),
                            buildTextField(
                              "Nama Ibu",
                              _namaIbuController,
                              formatters: onlyText(35),
                            ),
                            buildTextField(
                              "Nama Wali",
                              _namaWaliController,
                              formatters: onlyText(35),
                            ),
                            buildTextField(
                              "Alamat Orang Tua/Wali",
                              _alamatOrtuController,
                            ),
                          ]),

                          const SizedBox(height: 30),

                          // Tombol untuk menyimpan data ke Supabase dengan validasi dan error handling.
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                // Validasi form sebelum menyimpan.
                                if (_formKey.currentState!.validate()) {
                                  // Cek koneksi internet sebelum insert data.
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    // Error handling: Tidak ada koneksi internet.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Tidak ada koneksi internet. Silakan cek koneksi Anda.",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return; // Hentikan proses jika tidak ada internet.
                                  }

                                  try {
                                    // Insert data ke tabel 'siswa' di Supabase.
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
                                      'kecamatan':
                                          _kecamatanController.text,
                                      'kabupaten':
                                          _kabupatenController.text,
                                      'provinsi': _provinsiController.text,
                                      'kode_pos': _kodePosController.text,
                                      'nama_ayah': _namaAyahController.text,
                                      'nama_ibu': _namaIbuController.text,
                                      'nama_wali': _namaWaliController.text,
                                      'alamat_orang_tua_wali':
                                          _alamatOrtuController.text,
                                    });

                                    // Tampilkan pesan sukses dan reset form.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil disimpan'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    _formKey.currentState!.reset();
                                  } catch (e) {
                                    // Error handling: Masalah koneksi atau error dari Supabase.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error saat menyimpan data ke Supabase: $e',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
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

  // Fungsi reusable untuk mendefinisikan style input decoration.
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  // Fungsi reusable untuk membangun TextFormField dengan validasi required.
  Widget buildTextField(
    String label,
    TextEditingController controller, {
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        inputFormatters: formatters,
        decoration: inputDecoration(label),
        validator: (value) => (value == null || value.isEmpty)
            ? "$label tidak boleh kosong"
            : null,
      ),
    );
  }

  // Fungsi reusable untuk membangun DropdownButtonFormField dengan validasi required.
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
        validator: (value) => (value == null || value.isEmpty)
            ? "$label tidak boleh kosong"
            : null,
      ),
    );
  }

  // Fungsi reusable untuk membangun card section (misalnya untuk alamat atau orang tua).
  // Menerima judul dan list widget field.
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
            ...fields, // Menyebarkan list fields ke dalam column.
          ],
        ),
      ),
    );
  }
}