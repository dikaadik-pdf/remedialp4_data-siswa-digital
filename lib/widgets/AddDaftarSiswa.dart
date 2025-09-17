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
                          await Supabase.instance.client
                              .from('siswa')
                              .delete()
                              .eq('id', siswa['id']);
                          _loadSiswa();
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
