import 'form_field_model.dart';

class FormResponseModel {
  final String pageTitle;
  final String module;
  final String title;
  final String description;
  final String slug;
  final int totalQuestions;
  final List<FormFieldModel> data;

  FormResponseModel({
    required this.pageTitle,
    required this.module,
    required this.title,
    required this.description,
    required this.slug,
    required this.totalQuestions,
    required this.data,
  });

  factory FormResponseModel.fromJson(Map<String, dynamic> json) {
    return FormResponseModel(
      pageTitle: json['pageTitle'] ?? '',
      module: json['module'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageTitle': pageTitle,
      'module': module,
      'title': title,
      'description': description,
      'slug': slug,
      'total_questions': totalQuestions,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
