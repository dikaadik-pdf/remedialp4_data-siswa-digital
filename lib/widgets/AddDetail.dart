import 'package:flutter/material.dart';

class DetailSiswaScreen extends StatelessWidget {
  final Map<String, dynamic> siswa;
  const DetailSiswaScreen({super.key, required this.siswa});

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
              // 🔹 Header
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
                      "Detail Data Siswa",
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

              const SizedBox(height: 20),

              // 🔹 Keterangan judul halaman
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "DETAIL DATA SISWA SMK NEGERI SWASTA JAKAWARNA",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Card data siswa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Siswa",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Informasi pribadi
                        buildDetailItem("NISN", siswa['nisn']),
                        buildDetailItem("Nama Lengkap", siswa['nama_lengkap']),
                        buildDetailItem("Jenis Kelamin", siswa['jenis_kelamin']),
                        buildDetailItem("Agama", siswa['agama']),
                        buildDetailItem("Tempat Lahir", siswa['tempat_lahir']),
                        buildDetailItem("Tanggal Lahir", siswa['tanggal_lahir']),
                        buildDetailItem("No. Tlp/HP", siswa['no_tlp']),
                        buildDetailItem("NIK", siswa['nik']),

                        const SizedBox(height: 12),
                        const Divider(),
                        const Text(
                          "Alamat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                        const SizedBox(height: 8),
                        buildDetailItem("Jalan", siswa['jalan']),
                        buildDetailItem(
                          "RT/RW",
                          (siswa['rt'] == null && siswa['rw'] == null)
                              ? "-"
                              : "${siswa['rt'] ?? '-'} / ${siswa['rw'] ?? '-'}",
                        ),
                        buildDetailItem("Dusun", siswa['dusun']),
                        buildDetailItem("Desa", siswa['desa']),
                        buildDetailItem("Kecamatan", siswa['kecamatan']),
                        buildDetailItem("Kabupaten", siswa['kabupaten']),
                        buildDetailItem("Provinsi", siswa['provinsi']),
                        buildDetailItem("Kode Pos", siswa['kode_pos']),

                        const SizedBox(height: 12),
                        const Divider(),
                        const Text(
                          "Orang Tua / Wali",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                        const SizedBox(height: 8),
                        buildDetailItem("Nama Ayah", siswa['nama_ayah']),
                        buildDetailItem("Nama Ibu", siswa['nama_ibu']),
                        buildDetailItem("Nama Wali", siswa['nama_wali']),
                        buildDetailItem(
                            "Alamat Ortu/Wali", siswa['alamat_orang_tua_wali']),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Tombol kembali
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Kembali",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget detail item
  Widget buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "-",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
