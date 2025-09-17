import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final _stream =
      Supabase.instance.client.from('siswa').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text("Belum ada data siswa"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final siswa = data[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    siswa['nama_lengkap'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "NIK: ${siswa['nik'] ?? '-'}, NISN: ${siswa['nisn'] ?? '-'}\n${siswa['agama'] ?? '-'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black87),
                        onPressed: () {
                          // TODO: edit form
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black87),
                        onPressed: () async {
                          await Supabase.instance.client
                              .from('siswa')
                              .delete()
                              .eq('id', siswa['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
