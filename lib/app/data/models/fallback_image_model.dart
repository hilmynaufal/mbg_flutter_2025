class FallbackImageModel {
  final int id;
  final int idUser;
  final String? dokumentasiFoto1;
  final String? dokumentasiFoto2;
  final String? dokumentasiFoto3;
  final String? dokumentasiFoto1Url;
  final String? dokumentasiFoto2Url;
  final String? dokumentasiFoto3Url;
  final String? createdAt;
  final String? updatedAt;

  FallbackImageModel({
    required this.id,
    required this.idUser,
    this.dokumentasiFoto1,
    this.dokumentasiFoto2,
    this.dokumentasiFoto3,
    this.dokumentasiFoto1Url,
    this.dokumentasiFoto2Url,
    this.dokumentasiFoto3Url,
    this.createdAt,
    this.updatedAt,
  });

  factory FallbackImageModel.fromJson(Map<String, dynamic> json) {
    return FallbackImageModel(
      id: json['id'] ?? 0,
      idUser: json['id_user'] ?? 0,
      dokumentasiFoto1: json['dokumentasi_foto_1'],
      dokumentasiFoto2: json['dokumentasi_foto_2'],
      dokumentasiFoto3: json['dokumentasi_foto_3'],
      dokumentasiFoto1Url: json['dokumentasi_foto_1_url'],
      dokumentasiFoto2Url: json['dokumentasi_foto_2_url'],
      dokumentasiFoto3Url: json['dokumentasi_foto_3_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'dokumentasi_foto_1': dokumentasiFoto1,
      'dokumentasi_foto_2': dokumentasiFoto2,
      'dokumentasi_foto_3': dokumentasiFoto3,
      'dokumentasi_foto_1_url': dokumentasiFoto1Url,
      'dokumentasi_foto_2_url': dokumentasiFoto2Url,
      'dokumentasi_foto_3_url': dokumentasiFoto3Url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Get fallback URL by index (1, 2, or 3)
  String? getFallbackUrl(int index) {
    switch (index) {
      case 1:
        return dokumentasiFoto1Url;
      case 2:
        return dokumentasiFoto2Url;
      case 3:
        return dokumentasiFoto3Url;
      default:
        return null;
    }
  }
}
