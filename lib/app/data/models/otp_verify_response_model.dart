class OtpVerifyResponseModel {
  final bool success;
  final String message;
  final OtpVerifyData? data;

  OtpVerifyResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OtpVerifyData.fromJson(json['data']) : null,
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

class OtpVerifyData {
  final String email;
  final String verifiedAt;

  OtpVerifyData({
    required this.email,
    required this.verifiedAt,
  });

  factory OtpVerifyData.fromJson(Map<String, dynamic> json) {
    return OtpVerifyData(
      email: json['email'] ?? '',
      verifiedAt: json['verified_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verified_at': verifiedAt,
    };
  }
}
