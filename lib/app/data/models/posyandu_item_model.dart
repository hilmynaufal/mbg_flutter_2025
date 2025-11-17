import 'posyandu_detail_model.dart';

class PosyanduItemModel {
  final int id;
  final String? status;
  final String departmentId;
  final String departmentNama;
  final String asistantNama;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final PosyanduDetailModel detail;

  PosyanduItemModel({
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

  factory PosyanduItemModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse detail - handle both Map and potential other formats
      final detailData = json['detail'];
      final PosyanduDetailModel detail;

      if (detailData is Map<String, dynamic>) {
        detail = PosyanduDetailModel.fromJson(detailData);
      } else if (detailData is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        detail = PosyanduDetailModel.fromJson(
          Map<String, dynamic>.from(detailData),
        );
      } else {
        // Detail is not a map, use empty object
        detail = PosyanduDetailModel.fromJson({});
      }

      return PosyanduItemModel(
        id: json['id'] ?? 0,
        status: json['status'],
        departmentId: json['department_id']?.toString() ?? '',
        departmentNama: json['department_nama'] ?? '',
        asistantNama: json['asistant_nama'] ?? '',
        createdBy: json['created_by'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedBy: json['updated_by'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        detail: detail,
      );
    } catch (e) {
      // Add more detailed error logging
      print('Error parsing PosyanduItemModel: $e');
      print('JSON keys: ${json.keys}');
      print('Detail type: ${json['detail'].runtimeType}');
      rethrow;
    }
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
