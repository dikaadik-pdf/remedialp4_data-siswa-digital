import '../models/siswa.dart';

class StudentService {
  // ✅ Simpan data siswa sementara di list lokal
  static final List<Siswa> _students = [];

  /// Tambah data siswa
  void addStudent(Siswa siswa) {
    _students.add(siswa);
  }

  /// Ambil semua data siswa
  List<Siswa> getStudents() {
    return _students;
}
}