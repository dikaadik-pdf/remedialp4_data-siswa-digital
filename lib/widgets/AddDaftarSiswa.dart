import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AddDetail.dart';
import 'AddEditCard.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> _siswaList = [];

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  Future<void> _loadSiswa() async {
    final response = await Supabase.instance.client.from('siswa').select();
    setState(() {
      _siswaList = List<Map<String, dynamic>>.from(response);
    });
  }

  /// Fungsi dialog konfirmasi
  Future<bool> _showConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Apakah Anda Yakin Untuk Menghapus Data Ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Hapus"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Daftar Siswa Digital",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  "SMK Negeri Swasta Jakawarna",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),

          // BODY LIST
          Expanded(
            child: _siswaList.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada data siswa",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _siswaList.length,
                    itemBuilder: (context, index) {
                      final siswa = _siswaList[index];
                      return SiswaCard(
                        siswa: siswa,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailSiswaScreen(siswa: siswa),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirm = await _showConfirmDialog(context);
                          if (confirm) {
                            await Supabase.instance.client
                                .from('siswa')
                                .delete()
                                .eq('id', siswa['id']);
                            _loadSiswa();
                          }
                        },
                        onEdit: (updatedSiswa) async {
                          await Supabase.instance.client
                              .from('siswa')
                              .update(updatedSiswa)
                              .eq('id', updatedSiswa['id']);
                          _loadSiswa();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
