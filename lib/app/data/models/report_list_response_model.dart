import 'report_list_item_model.dart';

class ReportListResponseModel {
  final String status;
  final String message;
  final String pageTitle;
  final String title;
  final String slug;
  final String description;
  final int total;
  final List<ReportListItemModel> data;

  ReportListResponseModel({
    required this.status,
    required this.message,
    required this.pageTitle,
    required this.title,
    required this.slug,
    required this.description,
    required this.total,
    required this.data,
  });

  factory ReportListResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportListResponseModel(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      pageTitle: json['pageTitle'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ReportListItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'pageTitle': pageTitle,
      'title': title,
      'slug': slug,
      'description': description,
      'total': total,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
