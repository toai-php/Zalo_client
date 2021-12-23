import 'package:faker/faker.dart';

class ResponseData {
  late final String code;
  late final String message;
  late final dynamic data;

  ResponseData({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      code: json['code'] ?? "",
      message: json['message'] ?? "",
      data: json['data'],
    );
  }
}

class PostFaker {
  late int id;
  late String described;
  late DateTime created;
  late DateTime modified;
  late int like;
  late int commment;
  late bool isLiked;
  late List<String> images;
  late String video;
  late int author_id;
  late String author_name;
  late String author_avt;
  late bool isBlocked;
  late bool canEdit;
  late bool banned;
  late bool canComment;

  PostFaker.origin() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    described = faker.lorem.sentence();
    created = faker.date.dateTime(minYear: 2020, maxYear: 2021);
    modified = faker.date.dateTime(minYear: 2020, maxYear: 2021);
    like = faker.randomGenerator.integer(200);
    commment = faker.randomGenerator.integer(200);
    isLiked = faker.randomGenerator.boolean();

    author_id = faker.randomGenerator.integer(50);
    author_name = faker.person.name();
    author_avt = faker.image.image(random: true);
    isBlocked = faker.randomGenerator.boolean();
    canEdit = faker.randomGenerator.boolean();
    banned = faker.randomGenerator.boolean();
    canComment = faker.randomGenerator.boolean();

    images = [];
    video = '';
    bool isImg = faker.randomGenerator.boolean();
    if (isImg) {
      int imgCount = faker.randomGenerator.integer(4, min: 1);
      for (int i = 0; i < imgCount; i++) {
        images.add(faker.image.image(random: true));
      }
    } else {
      video = faker.image.image();
    }
  }
}
