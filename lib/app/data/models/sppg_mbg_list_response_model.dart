import 'sppg_mbg_item_model.dart';

class SppgMbgListResponseModel {
  final String status;
  final String message;
  final int total;
  final List<SppgMbgItemModel> data;

  SppgMbgListResponseModel({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  factory SppgMbgListResponseModel.fromJson(Map<String, dynamic> json) {
    return SppgMbgListResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  SppgMbgItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success';
}
