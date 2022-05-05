import 'package:faker/faker.dart';

import '../config/global_config.dart';

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

class ListPostResponseModel {
  late final String code;
  late final String message;
  late final List<PostModel> data;
  late final int newItems;
  late final int lastId;

  ListPostResponseModel(
      {required this.code,
      required this.message,
      required this.data,
      required this.newItems,
      required this.lastId});

  factory ListPostResponseModel.fromJson(Map<String, dynamic> data) {
    List<PostModel> dt = [];
    if (data['data']['posts'] != null) {
      List<dynamic> pst = data['data']['posts'];

      for (int i = 0; i < pst.length; i++) {
        dt.add(PostModel.fromJson(pst[i]));
      }
    }
    return ListPostResponseModel(
      code: data['code'] ?? "9999",
      message: data['message'] ?? "error",
      data: dt,
      newItems: data['new_items'] ?? 0,
      lastId: data['last_id'] ?? 0,
    );
  }
}

class PostModel {
  late int id;
  late String described;
  late DateTime created;
  late int like;
  late int commment;
  late bool isLiked;
  late List<String> images;
  late String video;
  late int authorId;
  late String authorName;
  late String authorAvt;
  late bool isBlocked;
  late bool canEdit;
  late bool canComment;

  PostModel({
    required this.id,
    required this.described,
    required this.created,
    required this.like,
    required this.commment,
    required this.isLiked,
    required this.images,
    required this.video,
    required this.authorId,
    required this.authorAvt,
    required this.authorName,
    required this.isBlocked,
    required this.canEdit,
    required this.canComment,
  });

  PostModel.fromFaker() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    described = faker.lorem.sentence();
    created = faker.date.dateTime(minYear: 2020, maxYear: 2021);
    like = faker.randomGenerator.integer(200);
    commment = faker.randomGenerator.integer(200);
    isLiked = faker.randomGenerator.boolean();

    authorId = faker.randomGenerator.integer(50);
    authorName = faker.person.name();
    authorAvt = faker.image.image(random: true);
    isBlocked = faker.randomGenerator.boolean();
    canEdit = faker.randomGenerator.boolean();
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

  factory PostModel.fromJson(Map<String, dynamic> data) {
    String host = 'http://' + GlobalConfig.host;

    List<String> img = [];
    String vid = "";

    List<dynamic> media = data['media'];
    if (media.isNotEmpty) {
      int i1 = media[0]['stt'];
      if (i1 == -1) {
        vid = host + media[0]['link'];
      } else {
        for (int i = 0; i < media.length; i++) {
          img.add(host + media[i]['link']);
        }
      }
    }

    String au_avt =
        "https://st3.depositphotos.com/1767687/16607/v/600/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg";
    if (data['author']['avtlink'] != null) {
      au_avt = data['author']['avtlink'];
    }

    var cr_time = DateTime.parse(data['created']);

    return PostModel(
        id: data['id'] ?? 0,
        described: data['described'] ?? "",
        created: cr_time,
        like: data['like'],
        commment: data['comment'],
        isLiked: data['is_liked'],
        images: img,
        video: vid,
        authorId: data['author']['id'],
        authorAvt: au_avt,
        authorName: data['author']['name'] ?? "User",
        isBlocked: data['is_blocked'],
        canEdit: data['can_edit'],
        canComment: data['can_comment']);
  }
}
