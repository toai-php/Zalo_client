import '../config/global_config.dart';

class ListUser {
  late String code;
  late String message;
  late List<UserModel> data;
  late int total;
  ListUser({
    required this.code,
    required this.message,
    required this.data,
    required this.total,
  });

  ListUser.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '9999';
    message = json['message'] ?? 'error';
    total = json['total'] ?? 0;
    data = [];
    final List<dynamic> list = json['data'];
    for (final ele in list) {
      data.add(UserModel.fromJson(ele));
    }
  }
}

class UserModel {
  late int id;
  late String name;
  late String avtlink;
  late int room;
  UserModel({
    required this.id,
    required this.name,
    required this.avtlink,
    required this.room,
  });
  UserModel.fromJson(Map<String, dynamic> data) {
    id = data['user_id'] ?? -1;
    name = data['user_name'] ?? 'User';
    avtlink = data['user_avtlink'] ??
        'http://' + GlobalConfig.host + '/img/default.jpg';
    room = data['room'] ?? -1;
  }
}
