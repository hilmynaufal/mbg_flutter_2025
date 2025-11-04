class OtpSendResponseModel {
  final bool success;
  final String message;
  final OtpSendData? data;

  OtpSendResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OtpSendResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpSendResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OtpSendData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class OtpSendData {
  final String email;
  final String expiresAt;

  OtpSendData({
    required this.email,
    required this.expiresAt,
  });

  factory OtpSendData.fromJson(Map<String, dynamic> json) {
    return OtpSendData(
      email: json['email'] ?? '',
      expiresAt: json['expires_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'expires_at': expiresAt,
    };
  }
}
