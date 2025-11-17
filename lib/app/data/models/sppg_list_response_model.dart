import 'sppg_item_model.dart';

class SppgListResponseModel {
  final String status;
  final String message;
  final String pageTitle;
  final String title;
  final String slug;
  final String description;
  final int total;
  final List<SppgItemModel> data;

  SppgListResponseModel({
    required this.status,
    required this.message,
    required this.pageTitle,
    required this.title,
    required this.slug,
    required this.description,
    required this.total,
    required this.data,
  });

  factory SppgListResponseModel.fromJson(Map<String, dynamic> json) {
    return SppgListResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      pageTitle: json['pageTitle'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      total: json['total'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => SppgItemModel.fromJson(item as Map<String, dynamic>))
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

  // Check if response is successful
  bool get isSuccess => status.toLowerCase() == 'success';
}
