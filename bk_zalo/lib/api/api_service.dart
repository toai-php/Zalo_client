import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/models/signin_model.dart';
import 'package:bk_zalo/models/signup_model.dart';

const String HOST = "10.0.2.2:3000";

class APIService {
  FutureOr<http.Response> onTimeOut() {
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

  Future<ResponseData> addPost(
      List<AssetEntity> images, AssetEntity? video, String? describe) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(
          code: "9999", message: "no internet connection", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9999", message: "user is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + HOST;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    var formData = FormData();
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        var file = await images[i].file;
        if (file != null) {
          String fileName = file.path.split('/').last;
          String fileType = fileName.split('.').last;
          formData.files.addAll([
            MapEntry(
                'images',
                MultipartFile.fromFileSync(
                  file.path,
                  filename: fileName,
                  contentType: MediaType('image', fileType),
                ))
          ]);
        }
      }
    } else if (video != null) {
      var file = await video.file;
      if (file != null) {
        String fileName = file.path.split('/').last;
        String fileType = fileName.split('.').last;
        formData.files.add(MapEntry(
            'video',
            MultipartFile.fromFileSync(file.path,
                filename: fileName,
                contentType: MediaType('video', fileType))));
      }
    }
    formData.fields.add(MapEntry('describe', describe!));
    print(formData.files.length);

    try {
      var response = await dio.post('/it4788/add_post', data: formData);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(code: '9999', message: 'no internet', data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: '9999', message: 'no internet', data: {});
    }
  }
}
