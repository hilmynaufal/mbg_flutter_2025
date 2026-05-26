class SppgMbgDetailModel {
  final String idSppg;
  final String kode;
  final String nama;
  final String provinsi;
  final String kab;
  final String kecamatan;
  final String desa;
  final String alamat;
  final String jenis;
  final String status;
  final String mulaiOpsnal;
  final String namaKaSppg;
  final String hpKaSppg;
  final String emailKaSppg;
  final String yayasan;

  SppgMbgDetailModel({
    required this.idSppg,
    required this.kode,
    required this.nama,
    required this.provinsi,
    required this.kab,
    required this.kecamatan,
    required this.desa,
    required this.alamat,
    required this.jenis,
    required this.status,
    required this.mulaiOpsnal,
    required this.namaKaSppg,
    required this.hpKaSppg,
    required this.emailKaSppg,
    required this.yayasan,
  });

  factory SppgMbgDetailModel.fromJson(Map<String, dynamic> json) {
    return SppgMbgDetailModel(
      idSppg: json['id_sppg'] ?? '',
      kode: json['kode'] ?? '',
      nama: json['nama'] ?? '',
      provinsi: json['provinsi'] ?? '',
      kab: json['kab'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desa: json['desa'] ?? '',
      alamat: json['alamat'] ?? '',
      jenis: json['jenis'] ?? '',
      status: json['status'] ?? '',
      mulaiOpsnal: json['mulai_opsnal'] ?? '',
      namaKaSppg: json['nama_ka_sppg'] ?? '',
      hpKaSppg: json['hp_ka_sppg'] ?? '',
      emailKaSppg: json['email_ka_sppg'] ?? '',
      yayasan: json['yayasan'] ?? '',
    );
  }

  String get normalizedNama => nama.trim().toLowerCase();
}
