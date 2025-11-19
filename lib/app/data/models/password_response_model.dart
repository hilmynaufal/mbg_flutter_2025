class PasswordResponseModel {
  final bool success;
  final String password;

  PasswordResponseModel({
    required this.success,
    required this.password,
  });

  factory PasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return PasswordResponseModel(
      success: json['success'] ?? false,
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'password': password,
    };
  }
}

