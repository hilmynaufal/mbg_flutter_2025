class ReportListItemModel {
  final int id;
  final dynamic departmentId; // Can be int or String (e.g., "Tamu")
  final String departmentNama;
  final String asistantNama;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;
  final Map<String, dynamic> detail;

  ReportListItemModel({
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

  factory ReportListItemModel.fromJson(Map<String, dynamic> json) {
    return ReportListItemModel(
      id: json['id'] as int,
      // Handle both int and string for department_id
      departmentId: json['department_id'] ?? 0,
      departmentNama: json['department_nama'] as String? ?? '',
      asistantNama: json['asistant_nama'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedBy: json['updated_by'] as String? ?? '',
      updatedAt: DateTime.parse(json['updated_at'] as String),
      detail: json['detail'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department_id': departmentId,
      'department_nama': departmentNama,
      'asistant_nama': asistantNama,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_by': updatedBy,
      'updated_at': updatedAt.toIso8601String(),
      'detail': detail,
    };
  }

  // Helper to get summary from detail
  String getSummary() {
    if (detail.containsKey('nama_sppg')) {
      return detail['nama_sppg'] as String? ?? 'Tanpa Nama';
    }
    return 'Laporan #$id';
  }

  // Helper to get location from detail
  String getLocation() {
    final kecamatan = detail['kecamatan'] as String? ?? '';
    final desa = detail['desa'] as String? ?? '';

    if (kecamatan.isNotEmpty && desa.isNotEmpty) {
      return '$desa, $kecamatan';
    } else if (kecamatan.isNotEmpty) {
      return kecamatan;
    } else if (desa.isNotEmpty) {
      return desa;
    }
    return '-';
  }
}
