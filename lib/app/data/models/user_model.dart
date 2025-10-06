class UserModel {
  final int id;
  final String username;
  final String? firebaseToken;
  final int idPegawai;
  final int level;
  final String nmLengkap;
  final String nip;
  final String? nik;
  final String? email;
  final String jabatan;
  final int jabatanId;
  final int idSkpdMaster;
  final String skpdNama;

  UserModel({
    required this.id,
    required this.username,
    this.firebaseToken,
    required this.idPegawai,
    required this.level,
    required this.nmLengkap,
    required this.nip,
    this.nik,
    this.email,
    required this.jabatan,
    required this.jabatanId,
    required this.idSkpdMaster,
    required this.skpdNama,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firebaseToken: json['firebase_token'],
      idPegawai: json['id_pegawai'] ?? 0,
      level: json['level'] ?? 0,
      nmLengkap: json['nm_lengkap'] ?? '',
      nip: json['nip'] ?? '',
      nik: json['nik'],
      email: json['email'],
      jabatan: json['jabatan'] ?? '',
      jabatanId: json['jabatan_id'] ?? 0,
      idSkpdMaster: json['id_skpd_master'] ?? 0,
      skpdNama: json['skpdnama'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firebase_token': firebaseToken,
      'id_pegawai': idPegawai,
      'level': level,
      'nm_lengkap': nmLengkap,
      'nip': nip,
      'nik': nik,
      'email': email,
      'jabatan': jabatan,
      'jabatan_id': jabatanId,
      'id_skpd_master': idSkpdMaster,
      'skpdnama': skpdNama,
    };
  }
}
