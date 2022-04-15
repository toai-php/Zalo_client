import 'package:shared_preferences/shared_preferences.dart';

class LoginResponseModel {
  late final String code;
  late final String message;
  late final dynamic data;

  LoginResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code'] ?? "",
      message: json['message'] ?? "",
      data: json['data'],
    );
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', data['username'] ?? 'User');
    await prefs.setInt('id', data['id'] ?? 0);
    await prefs.setString('avtlink',
        data['avatar'] ?? "http://192.168.7.104:3000/img/default.jpg");
    await prefs.setString('user_token', data['token'] ?? "");
  }
}

class LoginRequestModel {
  late String phoneNumber;
  late String password;

  LoginRequestModel({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phoneNumber.trim(),
      'passwd': password.trim(),
    };

    return map;
  }
}
