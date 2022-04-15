import 'package:bk_zalo/models/post_model.dart';

class ProfileModel {
  late final String code;
  late final String message;
  late final List<PostModel> data;
  late final int userId;
  late final String userName;
  late final String userAvt;
  late final int type;
  ProfileModel(
      {required this.code,
      required this.message,
      required this.data,
      required this.userId,
      required this.userName,
      required this.userAvt,
      required this.type});
  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    List<PostModel> dt = [];
    if (data['data']['posts'] != null) {
      List<dynamic> pst = data['data']['posts'];

      for (int i = 0; i < pst.length; i++) {
        dt.add(PostModel.fromJson(pst[i]));
      }
    }
    return ProfileModel(
        code: data['code'] ?? "9999",
        message: data['message'] ?? "error",
        data: dt,
        userName: data['user']['name'] ?? 'user',
        userAvt: data['user']['avtlink'] ??
            'http://192.168.7.104:3000/img/default.jpg',
        userId: data['user']['id'] ?? 0,
        type: data['type']);
  }
}
