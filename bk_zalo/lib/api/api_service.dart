import 'dart:async';
import 'dart:io';
import 'package:bk_zalo/models/signin_model.dart';
import 'package:bk_zalo/models/signup_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

const String HOST = "10.0.2.2:3000";

class APIService {
  FutureOr<Response> onTimeOut() {
    return http.Response('no internet', 404);
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final uri = Uri.http(HOST, "/it4788/login");

    bool hasInternet = await checkInternet();

    if (hasInternet == false) {
      return LoginResponseModel(
          code: '9999', message: 'no internet connection', data: {});
    }

    final response = await http
        .post(uri, body: requestModel.toJson())
        .timeout(const Duration(seconds: 2), onTimeout: onTimeOut);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      return LoginResponseModel(
          code: "9999", message: "no internet connection", data: {});
    }
  }

  Future<SignupResponseModel> signup(SignupRequestModel requestModel) async {
    final uri = Uri.http(HOST, "/it4788/signup");

    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return SignupResponseModel(
          code: "9999", message: "no internet connection", data: {});
    }

    final response = await http
        .post(uri, body: requestModel.toJson())
        .timeout(const Duration(seconds: 2), onTimeout: onTimeOut);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return SignupResponseModel.fromJson(json.decode(response.body));
    } else {
      return SignupResponseModel(
          code: "9999", message: "no internet connection", data: {});
    }
  }

  Future<GetUserModel> getUser(String phone) async {
    final uri = Uri.http(HOST, "/it4788/getuser");
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return GetUserModel(
          code: "9999", message: "no internet connection", data: {});
    }

    Map<String, String> map = {
      'phone': phone,
    };
    final response = await http.get(uri, headers: map).timeout(
          const Duration(seconds: 2),
          onTimeout: onTimeOut,
        );
    if (response.statusCode == 200 || response.statusCode == 400) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      return GetUserModel(code: '9999', message: 'no internet', data: {});
    }
  }
}
