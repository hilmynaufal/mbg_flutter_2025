import 'sppg_mbg_detail_model.dart';

class SppgMbgItemModel {
  final int id;
  final String? status;
  final dynamic departmentId;
  final String departmentNama;
  final String asistantNama;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final SppgMbgDetailModel detail;

  SppgMbgItemModel({
    required this.id,
    this.status,
    required this.departmentId,
    required this.departmentNama,
    required this.asistantNama,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.detail,
  });

  factory SppgMbgItemModel.fromJson(Map<String, dynamic> json) {
    return SppgMbgItemModel(
      id: json['id'] ?? 0,
      status: json['status'],
      departmentId: json['department_id'] ?? 0,
      departmentNama: json['department_nama'] ?? '',
      asistantNama: json['asistant_nama'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      detail: SppgMbgDetailModel.fromJson(json['detail'] ?? {}),
    );
  }
}
