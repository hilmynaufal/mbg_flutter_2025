import 'bedas_menanam_item_model.dart';

class BedasMenanamListResponseModel {
  final String status;
  final String message;
  final String pageTitle;
  final String title;
  final String slug;
  final String description;
  final int total;
  final List<BedasMenanamItemModel> data;

  BedasMenanamListResponseModel({
    required this.status,
    required this.message,
    required this.pageTitle,
    required this.title,
    required this.slug,
    required this.description,
    required this.total,
    required this.data,
  });

  factory BedasMenanamListResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      final dataList = json['data'];
      final List<BedasMenanamItemModel> parsedData = [];

      if (dataList is List) {
        for (var item in dataList) {
          try {
            if (item is Map<String, dynamic>) {
              parsedData.add(BedasMenanamItemModel.fromJson(item));
            } else if (item is Map) {
              parsedData.add(
                BedasMenanamItemModel.fromJson(Map<String, dynamic>.from(item)),
              );
            } else {
              print('Skipping invalid item type: ${item.runtimeType}');
            }
          } catch (e) {
            print('Error parsing item: $e');
            print('Item data: $item');
            continue; // Skip invalid items
          }
        }
      }

      return BedasMenanamListResponseModel(
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        pageTitle: json['pageTitle'] ?? '',
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
        description: json['description'] ?? '',
        total: json['total'] ?? parsedData.length,
        data: parsedData,
      );
    } catch (e) {
      print('Error parsing BedasMenanamListResponseModel: $e');
      print('JSON data: $json');
      rethrow;
    }
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

  bool get isSuccess => status.toLowerCase() == 'success';
}
