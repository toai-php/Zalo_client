import 'dart:async';
import 'dart:convert';
import 'package:bk_zalo/models/chat_model.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/models/conversation.dart';
import 'package:bk_zalo/models/profile_model.dart';
import 'package:bk_zalo/models/user_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/models/signin_model.dart';
import 'package:bk_zalo/models/signup_model.dart';

const String host = "192.168.1.12:3000";

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
    final uri = Uri.http(host, "/it4788/login");

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
    final uri = Uri.http(host, "/it4788/signup");

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
    final uri = Uri.http(host, "/it4788/getuser");
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
      return ResponseData(code: "9995", message: "user is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
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

    try {
      var response = await dio.post('/it4788/add_post', data: formData);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(code: '9999', message: 'no internet', data: {});
      }
    } catch (e) {
      return ResponseData(code: '9999', message: 'no internet', data: {});
    }
  }

  Future<ResponseData> editPost(int id, String? image_del, int? image_sort,
      List<AssetEntity> images, AssetEntity? video, String? describe) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(
          code: "9999", message: "no internet connection", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "user is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
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
    formData.fields.add(MapEntry('id', id.toString()));
    formData.fields.add(MapEntry('image_del', image_del!));
    formData.fields.add(MapEntry('image_sort', image_sort.toString()));

    try {
      var response = await dio.post('/it4788/edit_post', data: formData);
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

  Future<ListPostResponseModel> getListPost(
      int lastId, int index, int count) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListPostResponseModel(
          code: "9999", message: "message", data: [], newItems: 0, lastId: 0);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListPostResponseModel(
          code: "9995",
          message: "user is invalid",
          data: [],
          newItems: 0,
          lastId: 0);
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_list_post', data: {
        'index': index,
        'last_id': lastId,
        'count': count,
      });
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListPostResponseModel.fromJson(response.data);
      } else {
        return ListPostResponseModel(
            code: "9999", message: "message", data: [], newItems: 0, lastId: 0);
      }
    } catch (e) {
      print(e.toString());
      return ListPostResponseModel(
          code: "9999", message: "message", data: [], newItems: 0, lastId: 0);
    }
  }

  Future<ResponseData> deletePost(int id) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/delete_post', data: {'id': id});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }

  Future<ResponseData> deleteCmt(int id, int id_com) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio
          .post('/it4788/del_comment', data: {'id': id, 'id_com': id_com});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }

  Future<ListComment> getComment(int id, int index, int count) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListComment(
          code: "9999", message: "message", data: [], isBlocked: true);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListComment(
        code: "9995",
        message: "user is invalid",
        data: [],
        isBlocked: true,
      );
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_comment', data: {
        'index': index,
        'id': id,
        'count': count,
      });
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListComment.fromJson(response.data);
      } else {
        return ListComment(
            code: "9999", message: "message", data: [], isBlocked: true);
      }
    } catch (e) {
      print(e.toString());
      return ListComment(
          code: "9999", message: "message", data: [], isBlocked: true);
    }
  }

  Future<ResponseData> like(int id) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/like', data: {'id': id});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }

  Future<ResponseData> setComment(int id, String comment) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio
          .post('/it4788/set_comment', data: {'id': id, 'comment': comment});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }

  Future<ListConver> getListConver(int index, int count) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListConver(
          code: "9999", message: "message", data: [], numNewMessages: 0);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListConver(
        code: "9995",
        message: "user is invalid",
        data: [],
        numNewMessages: 0,
      );
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_list_conversation', data: {
        'index': index,
        'count': count,
      });
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListConver.fromJson(response.data);
      } else {
        return ListConver(
            code: "9999", message: "message", data: [], numNewMessages: 0);
      }
    } catch (e) {
      print(e.toString());
      return ListConver(
          code: "9999", message: "message", data: [], numNewMessages: 0);
    }
  }

  Future<ListChat> getListChat(int id, int index, int count) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListChat(
          code: "9999", message: "message", data: [], isBlocked: false);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListChat(
        code: "9995",
        message: "user is invalid",
        data: [],
        isBlocked: false,
      );
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_conversation', data: {
        'index': index,
        'id': id,
        'count': count,
      });
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListChat.fromJson(response.data);
      } else {
        return ListChat(
            code: "9999", message: "message", data: [], isBlocked: false);
      }
    } catch (e) {
      print(e.toString());
      return ListChat(
          code: "9999", message: "message", data: [], isBlocked: false);
    }
  }

  Future<ListUser> getListFriend() async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListUser(code: "9999", message: "message", data: [], total: 0);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListUser(
        code: "9995",
        message: "user is invalid",
        data: [],
        total: 0,
      );
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_list_friends');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListUser.fromJson(response.data);
      } else {
        return ListUser(code: "9999", message: "message", data: [], total: 0);
      }
    } catch (e) {
      print(e.toString());
      return ListUser(code: "9999", message: "message", data: [], total: 0);
    }
  }

  Future<ProfileModel> getProfile(int? id, String? phone) async {
    print(phone);
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ProfileModel(
          code: "9999",
          message: "message",
          data: [],
          userName: '0',
          userAvt: '',
          userId: 0,
          type: 0);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ProfileModel(
          code: "9995",
          message: "user is invalid",
          data: [],
          userName: '0',
          userAvt: '',
          userId: 0,
          type: 0);
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio
          .post('/it4788/get_profile', data: {'id': id, 'phone': phone});
      if (response.statusCode == 200 || response.statusCode == 400) {
        print('yes');
        return ProfileModel.fromJson(response.data);
      } else {
        return ProfileModel(
            code: "9999",
            message: "message",
            data: [],
            userName: '0',
            userAvt: '',
            userId: 0,
            type: 0);
      }
    } catch (e) {
      print(e.toString());
      return ProfileModel(
          code: "9999",
          message: "message",
          data: [],
          userName: '0',
          userAvt: '',
          userId: 0,
          type: 0);
    }
  }

  Future<ListUser> getListRequest() async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ListUser(code: "9999", message: "message", data: [], total: 0);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ListUser(
        code: "9995",
        message: "user is invalid",
        data: [],
        total: 0,
      );
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/get_request_friend');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ListUser.fromJson(response.data);
      } else {
        return ListUser(code: "9999", message: "message", data: [], total: 0);
      }
    } catch (e) {
      print(e.toString());
      return ListUser(code: "9999", message: "message", data: [], total: 0);
    }
  }

  Future<ResponseData> setRequestFriend(int id) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response =
          await dio.post('/it4788/set_request_friend', data: {'user_id': id});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }

  Future<ResponseData> setAcceptFriend(int id, int isAccept) async {
    bool hasInternet = await checkInternet();
    if (hasInternet == false) {
      return ResponseData(code: "9999", message: "no internet", data: {});
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      return ResponseData(code: "9995", message: "User is invalid", data: {});
    }

    var dio = Dio();
    dio.options.baseUrl = 'http://' + host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['token'] = token;

    try {
      var response = await dio.post('/it4788/set_accept_friend',
          data: {'user_id': id, 'is_accept': isAccept});
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ResponseData.fromJson(response.data);
      } else {
        return ResponseData(
            code: "9999", message: "can connect to server", data: {});
      }
    } catch (e) {
      print(e.toString());
      return ResponseData(code: "9999", message: "Error", data: {});
    }
  }
}
