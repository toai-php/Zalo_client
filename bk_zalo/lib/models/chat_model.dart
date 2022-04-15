import 'package:faker/faker.dart';

class ListChat {
  late String code;
  late String message;
  late List<ChatModel> data;
  late bool isBlocked;
  ListChat({
    required this.code,
    required this.message,
    required this.data,
    required this.isBlocked,
  });
  ListChat.fromFaker(int cnt) {
    code = '1000';
    message = 'OK';
    isBlocked = false;
    data = [];
    for (int i = 0; i < cnt; i++) {
      data.add(ChatModel.fromFaker());
    }
  }

  ListChat.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '9999';
    message = json['message'] ?? 'error';
    data = [];
    isBlocked = json['is_blocked'];
    List<dynamic> list = json['data'];
    for (int i = 0; i < list.length; i++) {
      data.add(ChatModel.fromJson(list[i]));
    }
  }
}

class ChatModel {
  late int id;
  late String message;
  late bool unread;
  late DateTime created;
  late int senderId;
  late String senderName;
  late String senderAvt;
  ChatModel({
    required this.id,
    required this.message,
    required this.unread,
    required this.created,
    required this.senderId,
    required this.senderName,
    required this.senderAvt,
  });

  ChatModel.fromSocket(Map<String, dynamic> data) {
    id = data['message_id'] ?? -1;
    message = data['content'] ?? '';
    unread = (data['unread'] == 1) ? true : false;
    created = DateTime.parse(data['created']);
    senderId = data['sender']['id'] ?? 0;
    senderName = data['sender']['name'] ?? 'User';
    senderAvt =
        data['sender']['avtlink'] ?? 'http://192.168.7.104:3000/img/default.jpg';
  }

  ChatModel.fromJson(Map<String, dynamic> data) {
    id = data['message_id'] ?? 0;
    message = data['message'] ?? '';
    unread = data['unread'] == 1 ? true : false;
    senderId = data['sender']['id'];
    senderName = data['sender']['username'];
    senderAvt = data['sender']['avtlink'];
    created = DateTime.parse(data['created']);
  }

  ChatModel.fromFaker() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    message = faker.lorem.sentence();
    created = faker.date.dateTime(minYear: 2020, maxYear: 2021);

    senderId = faker.randomGenerator.integer(50);
    senderName = faker.person.name();
    senderAvt = faker.image.image(random: true);
    unread = faker.randomGenerator.boolean();
  }
}
