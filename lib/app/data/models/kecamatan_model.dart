class KecamatanModel {
  final String kdKab;
  final String idKec;
  final String nmKec;

  KecamatanModel({
    required this.kdKab,
    required this.idKec,
    required this.nmKec,
  });

  factory KecamatanModel.fromMap(Map<String, String> map) {
    return KecamatanModel(
      kdKab: map['kd_kab']!,
      idKec: map['id_kec']!,
      nmKec: map['nm_kec']!,
    );
  }

  Map<String, String> toMap() {
    return {
      'kd_kab': kdKab,
      'id_kec': idKec,
      'nm_kec': nmKec,
    };
  }
}
