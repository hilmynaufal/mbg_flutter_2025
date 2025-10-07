class FormSubmitResponseModel {
  final int id;
  final String token;
  final int formId;
  final int? userId;
  final String submittedAt;
  final int? skpdId;
  final String? skpdNama;
  final String description;
  final String createdAt;
  final String updatedAt;

  FormSubmitResponseModel({
    required this.id,
    required this.token,
    required this.formId,
    this.userId,
    required this.submittedAt,
    this.skpdId,
    this.skpdNama,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FormSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return FormSubmitResponseModel(
      id: json['id'] as int,
      token: json['token'] as String,
      formId: json['form_id'] as int,
      userId: json['user_id'] as int?,
      submittedAt: json['submitted_at'] as String,
      skpdId: json['skpd_id'] as int?,
      skpdNama: json['skpd_nama'] as String?,
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'form_id': formId,
      'user_id': userId,
      'submitted_at': submittedAt,
      'skpd_id': skpdId,
      'skpd_nama': skpdNama,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
