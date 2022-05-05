import 'package:bk_zalo/controller/cache_controller.dart';

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
    await CacheController.saveData(data, 'user');
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
