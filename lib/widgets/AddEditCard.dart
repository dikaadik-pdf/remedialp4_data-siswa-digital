import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(
          siswa['nama_lengkap'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "NISN: ${siswa['nisn'] ?? ''}\nJenis Kelamin: ${siswa['jenis_kelamin'] ?? ''}",
        ),
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
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) =>
                      EditSiswaForm(siswa: Map<String, dynamic>.from(siswa)),
                );
                if (updatedSiswa != null) onEdit(updatedSiswa);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
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
  late TextEditingController _jalanController;
  late TextEditingController _rtController;
  late TextEditingController _rwController;
  late TextEditingController _dusunController;
  late TextEditingController _desaController;
  late TextEditingController _kecamatanController;
  late TextEditingController _kabupatenController;
  late TextEditingController _provinsiController;
  late TextEditingController _kodePosController;

  // Orang Tua / Wali
  late TextEditingController _namaAyahController;
  late TextEditingController _namaIbuController;
  late TextEditingController _namaWaliController;
  late TextEditingController _alamatOrtuController;

  @override
  void initState() {
    super.initState();
    final s = widget.siswa;

    _nisnController = TextEditingController(text: s['nisn']?.toString() ?? '');
    _namaController =
        TextEditingController(text: s['nama_lengkap']?.toString() ?? '');
    _selectedGender = s['jenis_kelamin']?.toString() ?? '';
    _selectedReligion = s['agama']?.toString() ?? '';
    _tempatLahirController =
        TextEditingController(text: s['tempat_lahir']?.toString() ?? '');
    _tanggalLahirController =
        TextEditingController(text: s['tanggal_lahir']?.toString() ?? '');
    _noHpController =
        TextEditingController(text: s['no_tlp']?.toString() ?? '');
    _nikController = TextEditingController(text: s['nik']?.toString() ?? '');
    _jalanController = TextEditingController(text: s['jalan']?.toString() ?? '');
    _rtController = TextEditingController(text: s['rt']?.toString() ?? '');
    _rwController = TextEditingController(text: s['rw']?.toString() ?? '');
    _dusunController =
        TextEditingController(text: s['dusun']?.toString() ?? '');
    _desaController = TextEditingController(text: s['desa']?.toString() ?? '');
    _kecamatanController =
        TextEditingController(text: s['kecamatan']?.toString() ?? '');
    _kabupatenController =
        TextEditingController(text: s['kabupaten']?.toString() ?? '');
    _provinsiController =
        TextEditingController(text: s['provinsi']?.toString() ?? '');
    _kodePosController =
        TextEditingController(text: s['kode_pos']?.toString() ?? '');

    _namaAyahController =
        TextEditingController(text: s['nama_ayah']?.toString() ?? '');
    _namaIbuController =
        TextEditingController(text: s['nama_ibu']?.toString() ?? '');
    _namaWaliController =
        TextEditingController(text: s['nama_wali']?.toString() ?? '');
    _alamatOrtuController = TextEditingController(
        text: s['alamat_orang_tua_wali']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nisnController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -3)),
              ],
            ),
            child: SingleChildScrollView(
              controller: controller,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 15),
                  const Text(
                    "Edit Data Siswa",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField("NISN", _nisnController,
                            keyboard: TextInputType.number),
                        buildTextField("Nama Lengkap", _namaController),
                        buildDropdownField(
                            "Jenis Kelamin",
                            ["Laki-laki", "Perempuan"],
                            _selectedGender,
                            (val) => setState(() => _selectedGender = val)),
                        buildDropdownField(
                            "Agama",
                            [
                              "Islam",
                              "Kristen",
                              "Katolik",
                              "Hindu",
                              "Buddha",
                              "Konghucu"
                            ],
                            _selectedReligion,
                            (val) => setState(() => _selectedReligion = val)),
                        buildTextField("Tempat Lahir", _tempatLahirController),
                        buildTextField("Tanggal Lahir", _tanggalLahirController,
                            readOnly: true, onTap: () async {
                          DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(_tanggalLahirController.text) ?? DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now());
                          if (picked != null) {
                            _tanggalLahirController.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          }
                        }),
                        buildTextField("No HP", _noHpController,
                            keyboard: TextInputType.phone),
                        buildTextField("NIK", _nikController,
                            keyboard: TextInputType.number),
                        const SizedBox(height: 15),
                        const Text("Alamat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange)),
                        buildTextField("Jalan", _jalanController),
                        buildRtRwField(), // 🔥 RT/RW dipisah
                        buildDusunAutocomplete(),
                        buildTextField("Desa", _desaController),
                        buildTextField("Kecamatan", _kecamatanController),
                        buildTextField("Kabupaten", _kabupatenController),
                        buildTextField("Provinsi", _provinsiController),
                        buildTextField("Kode Pos", _kodePosController),
                        const SizedBox(height: 15),
                        const Text("Data Orang Tua / Wali",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange)),
                        buildTextField("Nama Ayah", _namaAyahController),
                        buildTextField("Nama Ibu", _namaIbuController),
                        buildTextField("Nama Wali", _namaWaliController),
                        buildTextField(
                            "Alamat Orang Tua/Wali", _alamatOrtuController),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.grey, width: 1)),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "assets/images/logo.png",
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(Icons.school, size: 80, color: Colors.deepOrange);
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "Apakah Anda Yakin\nMenyimpan Data Baru?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.grey[200],
                                                    foregroundColor: Colors.black,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.pop(ctx, false),
                                                  child: const Text("Kembali"),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.deepOrange,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.pop(ctx, true),
                                                  child: const Text("Simpan"),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                    );

                                    if (confirm != true) return;

                                    final data = {
                                      'nisn': _nisnController.text,
                                      'nama_lengkap': _namaController.text,
                                      'jenis_kelamin': _selectedGender,
                                      'agama': _selectedReligion,
                                      'tempat_lahir': _tempatLahirController.text,
                                      'tanggal_lahir': _tanggalLahirController.text,
                                      'no_tlp': _noHpController.text,
                                      'nik': _nikController.text,
                                      'jalan': _jalanController.text,
                                      'rt': _rtController.text,
                                      'rw': _rwController.text,
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
                                    };

                                    final cleanData = data.map((k, v) => MapEntry(k, v?.toString() ?? ''));

                                    try {
                                      final updated = await Supabase.instance.client
                                          .from('siswa')
                                          .update(cleanData)
                                          .eq('id', widget.siswa['id'])
                                          .select()
                                          .single();

                                      if (!mounted) return;
                                      Navigator.pop(context, updated);
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Gagal menyimpan: $e')),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const Text("Simpan"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔥 Field RT dan RW dipisah
  Widget buildRtRwField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _rtController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                counterText: "",
                labelText: "RT",
                floatingLabelStyle: const TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepOrange)),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "RT wajib diisi" : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _rwController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                counterText: "",
                labelText: "RW",
                floatingLabelStyle: const TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepOrange)),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "RW wajib diisi" : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboard,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(
              color: Colors.deepOrange, fontWeight: FontWeight.bold),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange)),
        ),
        validator: (val) =>
            val == null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value != null && value.isNotEmpty ? value : null,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(
              color: Colors.deepOrange, fontWeight: FontWeight.bold),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange)),
        ),
        items: items
            .map((e) =>
                DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 16))))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null || val.isEmpty ? "$label kosong" : null,
      ),
    );
  }

  Widget buildDusunAutocomplete() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TypeAheadFormField<Map<String, dynamic>?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _dusunController,
        decoration: InputDecoration(
          labelText: "Dusun",
          floatingLabelStyle: const TextStyle(
              color: Colors.deepOrange, fontWeight: FontWeight.bold),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange)),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return [];
        try {
          final response = await Supabase.instance.client
              .from('locations')
              .select('dusun, desa, kecamatan, kabupaten, provinsi, kode_pos')
              .or('dusun.ilike.%$pattern%,desa.ilike.%$pattern%,kecamatan.ilike.%$pattern%')
              .order('dusun')
              .limit(50);

          final List<Map<String, dynamic>> allData = 
              (response as List).cast<Map<String, dynamic>>();
          
          // Remove duplicates berdasarkan kombinasi unik
          final Map<String, Map<String, dynamic>> uniqueMap = {};
          
          for (final item in allData) {
            final dusun = item['dusun']?.toString() ?? '';
            final desa = item['desa']?.toString() ?? '';
            final kecamatan = item['kecamatan']?.toString() ?? '';
            
            if (dusun.isNotEmpty) {
              final key = '$dusun|$desa|$kecamatan'.toLowerCase();
              if (!uniqueMap.containsKey(key)) {
                uniqueMap[key] = item;
              }
            }
          }

          return uniqueMap.values.take(10).toList();
        } catch (e) {
          print('Error fetching locations: $e');
          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        if (suggestion == null) return const SizedBox.shrink();
        
        final dusun = suggestion['dusun']?.toString() ?? '';
        final desa = suggestion['desa']?.toString() ?? '';
        final kecamatan = suggestion['kecamatan']?.toString() ?? '';
        final kabupaten = suggestion['kabupaten']?.toString() ?? '';
        
        return ListTile(
          title: Text(
            dusun,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '$desa, $kecamatan\n$kabupaten',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          isThreeLine: true,
          dense: true,
        );
      },
      onSuggestionSelected: (suggestion) {
        if (suggestion == null) return;
        
        _dusunController.text = suggestion['dusun']?.toString() ?? '';
        _desaController.text = suggestion['desa']?.toString() ?? '';
        _kecamatanController.text = suggestion['kecamatan']?.toString() ?? '';
        _kabupatenController.text = suggestion['kabupaten']?.toString() ?? '';
        _provinsiController.text = suggestion['provinsi']?.toString() ?? '';
        _kodePosController.text = suggestion['kode_pos']?.toString() ?? '';
        
        // Unfocus untuk menutup keyboard
        FocusScope.of(context).unfocus();
      },
      validator: (val) => val == null || val.isEmpty ? "Dusun wajib diisi" : null,
      noItemsFoundBuilder: (context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Tidak ada data ditemukan',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      loadingBuilder: (context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Mencari data...'),
          ],
        ),
      ),
      hideOnEmpty: true,
      hideOnLoading: false,
      animationDuration: const Duration(milliseconds: 300),
    ),
  );
}
}