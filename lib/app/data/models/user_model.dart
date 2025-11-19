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
  final String userType; // "PNS", "NON_PNS", or "GUEST"

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
    this.userType = 'PNS', // Default to PNS for backward compatibility
  });

  // Factory constructor for Non-PNS users
  factory UserModel.nonPns({
    required String nik,
    required String nama,
    required String email,
  }) {
    return UserModel(
      id: 0,
      username: nik, // Use NIK as username identifier
      firebaseToken: null,
      idPegawai: 0,
      level: 0,
      nmLengkap: nama,
      nip: '',
      nik: nik,
      email: email,
      jabatan: '',
      jabatanId: 0,
      idSkpdMaster: 0,
      skpdNama: '',
      userType: 'NON_PNS',
    );
  }

  // Factory constructor for Guest users
  factory UserModel.guest() {
    return UserModel(
      id: 0,
      username: 'guest',
      firebaseToken: null,
      idPegawai: 0,
      level: 0,
      nmLengkap: 'Pengguna Tamu',
      nip: '',
      nik: null,
      email: null,
      jabatan: '',
      jabatanId: 0,
      idSkpdMaster: 0,
      skpdNama: '',
      userType: 'GUEST',
    );
  }

  // Getter to check if user is PNS
  bool get isPns => userType == 'PNS';

  // Getter to check if user is Non-PNS
  bool get isNonPns => userType == 'NON_PNS';

  // Getter to check if user is Guest
  bool get isGuest => userType == 'GUEST';

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
      userType: json['user_type'] ?? 'PNS', // Default to PNS for backward compatibility
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
      'user_type': userType,
    };
  }
}
