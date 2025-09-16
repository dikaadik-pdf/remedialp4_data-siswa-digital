class Siswa {
  final int? id;
  final String nisn;
  final String namaLengkap;
  final String? jenisKelamin;
  final String? agama;
  final String? ttl;
  final String? noHp;
  final String? nik;

  // alamat
  final String? jalan;
  final String? rtRw;
  final String? dusun;
  final String? desa;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final String? kodePos;

  // orang tua
  final String? namaAyah;
  final String? namaIbu;
  final String? namaWali;
  final String? alamatOrtu;

  Siswa({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    this.jenisKelamin,
    this.agama,
    this.ttl,
    this.noHp,
    this.nik,
    this.jalan,
    this.rtRw,
    this.dusun,
    this.desa,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.kodePos,
    this.namaAyah,
    this.namaIbu,
    this.namaWali,
    this.alamatOrtu,
  });
}
