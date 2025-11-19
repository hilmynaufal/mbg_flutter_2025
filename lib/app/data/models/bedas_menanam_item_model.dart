import 'bedas_menanam_detail_model.dart';

class BedasMenanamItemModel {
  final int id;
  final String departmentId;
  final String departmentNama;
  final String asistantNama;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final BedasMenanamDetailModel detail;

  BedasMenanamItemModel({
    required this.id,
    required this.departmentId,
    required this.departmentNama,
    required this.asistantNama,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.detail,
  });

  factory BedasMenanamItemModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse detail - handle both Map types
      final detailData = json['detail'];
      final BedasMenanamDetailModel detail;

      if (detailData is Map<String, dynamic>) {
        detail = BedasMenanamDetailModel.fromJson(detailData);
      } else if (detailData is Map) {
        detail = BedasMenanamDetailModel.fromJson(
          Map<String, dynamic>.from(detailData),
        );
      } else {
        print('Invalid detail data type: ${detailData.runtimeType}');
        detail = BedasMenanamDetailModel.fromJson({});
      }

      return BedasMenanamItemModel(
        id: json['id'] ?? 0,
        departmentId: json['department_id'] ?? '',
        departmentNama: json['department_nama'] ?? '',
        asistantNama: json['asistant_nama'] ?? '',
        createdBy: json['created_by'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedBy: json['updated_by'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        detail: detail,
      );
    } catch (e) {
      print('Error parsing BedasMenanamItemModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
