import 'menu_opd_detail_model.dart';

/// Model for a single OPD menu item
/// Contains standard metadata fields and menu detail
class MenuOpdItemModel {
  final int id;
  final String? status;
  final int departmentId;
  final String departmentNama;
  final String asistantNama;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final MenuOpdDetailModel detail;

  MenuOpdItemModel({
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

  factory MenuOpdItemModel.fromJson(Map<String, dynamic> json) {
    return MenuOpdItemModel(
      id: json['id'] ?? 0,
      status: json['status'],
      departmentId: json['department_id'] ?? 0,
      departmentNama: json['department_nama'] ?? '',
      asistantNama: json['asistant_nama'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      detail: MenuOpdDetailModel.fromJson(json['detail'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'department_id': departmentId,
      'department_nama': departmentNama,
      'asistant_nama': asistantNama,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_by': updatedBy,
      'updated_at': updatedAt,
      'detail': detail.toJson(),
    };
  }
}
