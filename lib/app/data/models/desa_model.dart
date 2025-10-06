class DesaModel {
  final String kdKab;
  final String idDesa;
  final String nmDesa;

  DesaModel({
    required this.kdKab,
    required this.idDesa,
    required this.nmDesa,
  });

  // Get kecamatan ID from desa ID (first 6 digits)
  String get idKec => idDesa.substring(0, 6);

  factory DesaModel.fromMap(Map<String, String> map) {
    return DesaModel(
      kdKab: map['kd_kab']!,
      idDesa: map['id_desa']!,
      nmDesa: map['nm_desa']!,
    );
  }

  Map<String, String> toMap() {
    return {
      'kd_kab': kdKab,
      'id_desa': idDesa,
      'nm_desa': nmDesa,
    };
  }
}
