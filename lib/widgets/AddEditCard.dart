import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaCard extends StatelessWidget {
  final Map<String, dynamic> siswa;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) onEdit;

  const SiswaCard({
    super.key,
    required this.siswa,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(siswa['nama_lengkap']),
        subtitle: Text(
            "NISN: ${siswa['nisn']}\nJenis Kelamin: ${siswa['jenis_kelamin']}"),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                Map<String, dynamic>? updatedSiswa =
                    await showModalBottomSheet<Map<String, dynamic>>(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => EditSiswaForm(siswa: Map.from(siswa)),
                );

                if (updatedSiswa != null) {
                  onEdit(updatedSiswa);
                }
              },
            ),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

class EditSiswaForm extends StatefulWidget {
  final Map<String, dynamic> siswa;
  const EditSiswaForm({super.key, required this.siswa});

  @override
  State<EditSiswaForm> createState() => _EditSiswaFormState();
}

class _EditSiswaFormState extends State<EditSiswaForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nisnController;
  late TextEditingController _namaController;
  late String? _selectedGender;
  late String? _selectedReligion;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _noHpController;
  late TextEditingController _nikController;
  late TextEditingController _alamatController;
  late TextEditingController _ayahController;
  late TextEditingController _ibuController;
  late TextEditingController _waliController;

  @override
  void initState() {
    super.initState();
    final s = widget.siswa;
    _nisnController = TextEditingController(text: s['nisn']);
    _namaController = TextEditingController(text: s['nama_lengkap']);
    _selectedGender = s['jenis_kelamin'];
    _selectedReligion = s['agama'];
    _tempatLahirController = TextEditingController(text: s['tempat_lahir']);
    _tanggalLahirController = TextEditingController(text: s['tanggal_lahir']);
    _noHpController = TextEditingController(text: s['no_tlp']);
    _nikController = TextEditingController(text: s['nik']);
    _alamatController = TextEditingController(text: s['alamat']);
    _ayahController = TextEditingController(text: s['ayah']);
    _ibuController = TextEditingController(text: s['ibu']);
    _waliController = TextEditingController(text: s['wali']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Data Siswa", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField("NISN", _nisnController, keyboard: TextInputType.number),
                  buildTextField("Nama Lengkap", _namaController),
                  buildDropdownField("Jenis Kelamin", ["Laki-laki","Perempuan","Lainnya"], _selectedGender, (val)=>setState(()=>_selectedGender=val)),
                  buildDropdownField("Agama", ["Islam","Kristen","Katolik","Hindu","Buddha","Konghucu","Lainnya"], _selectedReligion, (val)=>setState(()=>_selectedReligion=val)),
                  buildTextField("Tempat Lahir", _tempatLahirController),
                  buildTextField("Tanggal Lahir", _tanggalLahirController, readOnly: true, onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(_tanggalLahirController.text) ?? DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if(picked!=null) _tanggalLahirController.text = "${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
                  }),
                  buildTextField("No HP", _noHpController, keyboard: TextInputType.phone),
                  buildTextField("NIK", _nikController, keyboard: TextInputType.number),
                  buildTextField("Alamat", _alamatController),
                  buildTextField("Nama Ayah", _ayahController),
                  buildTextField("Nama Ibu", _ibuController),
                  buildTextField("Wali", _waliController),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: ()=>Navigator.pop(context), child: const Text("Kembali"))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              final data = {
                                'nisn': _nisnController.text,
                                'nama_lengkap': _namaController.text,
                                'jenis_kelamin': _selectedGender,
                                'agama': _selectedReligion,
                                'tempat_lahir': _tempatLahirController.text,
                                'tanggal_lahir': _tanggalLahirController.text,
                                'no_tlp': _noHpController.text,
                                'nik': _nikController.text,
                                'alamat': _alamatController.text,
                                'ayah': _ayahController.text,
                                'ibu': _ibuController.text,
                                'wali': _waliController.text,
                              };
                              await Supabase.instance.client.from('siswa').update(data).eq('id', widget.siswa['id']);
                              Navigator.pop(context, {'id': widget.siswa['id'], ...data});
                            }
                          },
                          child: const Text("Simpan"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType? keyboard, bool readOnly=false, VoidCallback? onTap}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        onTap: onTap,
        decoration: inputDecoration(label),
        validator: (val) => val==null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? value, ValueChanged<String?> onChanged){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: inputDecoration(label),
        items: items.map((e) => DropdownMenuItem(value:e,child:Text(e))).toList(),
        onChanged: onChanged,
        validator: (val)=> val==null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  InputDecoration inputDecoration(String label){
    return InputDecoration(
      hintText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepOrange)),
    );
  }
}
