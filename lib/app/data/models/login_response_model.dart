import 'user_model.dart';

class LoginResponseModel {
  final int code;
  final List<UserModel> dataUsers;

  LoginResponseModel({
    required this.code,
    required this.dataUsers,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code'] ?? 0,
      dataUsers: (json['dataUsers'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'dataUsers': dataUsers.map((e) => e.toJson()).toList(),
    };
  }

  bool get isSuccess => code == 200 && dataUsers.isNotEmpty;
  UserModel? get user => dataUsers.isNotEmpty ? dataUsers.first : null;
}
