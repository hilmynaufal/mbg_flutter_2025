import 'posyandu_item_model.dart';

class PosyanduListResponseModel {
  final String status;
  final String message;
  final String pageTitle;
  final String title;
  final String slug;
  final String description;
  final int total;
  final List<PosyanduItemModel> data;

  PosyanduListResponseModel({
    required this.status,
    required this.message,
    required this.pageTitle,
    required this.title,
    required this.slug,
    required this.description,
    required this.total,
    required this.data,
  });

  factory PosyanduListResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse data list with better error handling
      final dataList = json['data'];
      final List<PosyanduItemModel> parsedData = [];

      if (dataList is List) {
        for (var item in dataList) {
          try {
            if (item is Map<String, dynamic>) {
              parsedData.add(PosyanduItemModel.fromJson(item));
            } else if (item is Map) {
              // Convert Map<dynamic, dynamic> to Map<String, dynamic>
              parsedData.add(
                PosyanduItemModel.fromJson(Map<String, dynamic>.from(item)),
              );
            } else {
              print('Skipping invalid item type: ${item.runtimeType}');
            }
          } catch (e) {
            print('Error parsing Posyandu item: $e');
            // Skip invalid items instead of failing completely
            continue;
          }
        }
      }

      return PosyanduListResponseModel(
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
      print('Error parsing PosyanduListResponseModel: $e');
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

  // Check if response is successful
  bool get isSuccess => status.toLowerCase() == 'success';
}
