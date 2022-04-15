import 'package:faker/faker.dart';

class ListConver {
  late final String code;
  late final String message;
  late final List<ConversationModel> data;
  late final int numNewMessages;
  ListConver({
    required this.code,
    required this.message,
    required this.data,
    required this.numNewMessages,
  });

  ListConver.fromFaker(int cnt) {
    code = '1000';
    message = 'OK';
    data = [];
    for (int i = 0; i < cnt; i++) {
      data.add(ConversationModel.fromFaker());
    }
    int n = 0;
    for (final ele in data) {
      if (ele.numUnread > 0) n++;
    }
    numNewMessages = n;
  }

  ListConver.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '9999';
    message = json['message'] ?? 'error';
    data = [];
    List<dynamic> jsonList = json['data'];
    for (int i = 0; i < jsonList.length; i++) {
      data.add(ConversationModel.fromJson(jsonList[i]));
    }
    numNewMessages = json['numNewMessages'];
  }
}

class ConversationModel {
  late int id;
  late int partnerId;
  late String partnerName;
  late String partnerAvt;
  late String lastMessage;
  late DateTime created;
  late int numUnread;
  ConversationModel({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvt,
    required this.lastMessage,
    required this.created,
    required this.numUnread,
  });

  ConversationModel.fromFaker() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    partnerId = faker.randomGenerator.integer(50);
    partnerName = faker.person.name();
    partnerAvt = faker.image.image(random: true);
    lastMessage = faker.lorem.sentence();
    created = faker.date.dateTime(minYear: 2021, maxYear: 2021);
    numUnread = faker.randomGenerator.integer(5);
  }

  ConversationModel.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? 0;
    partnerId = data['partner']['id'] ?? 0;
    partnerName = data['partner']['username'] ?? 'user';
    partnerAvt = data['partner']['avtlink'] ??
        'http://192.168.7.104:3000/img/default.jpg';
    lastMessage = data['lastmessage']['message'] ?? '';
    created = DateTime.parse(data['lastmessage']['created']);
    numUnread = data['lastmessage']['unread'];
  }
}
