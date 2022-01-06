import 'package:faker/faker.dart';

class ListComment {
  late String code;
  late String message;
  late List<CommentModel> data;
  late bool isBlocked;

  ListComment(
      {required this.code,
      required this.message,
      required this.data,
      required this.isBlocked});

  factory ListComment.fromJson(Map<String, dynamic> data) {
    List<CommentModel> dt = [];
    if (data['data'] != null) {
      List<dynamic> pst = data['data'];

      for (int i = 0; i < pst.length; i++) {
        dt.add(CommentModel.fromJson(pst[i]));
      }
    }
    return ListComment(
        code: data['code'] ?? '9999',
        message: data['message'] ?? 'error',
        data: dt,
        isBlocked: data['is_blocked'] ?? true);
  }
}

class CommentModel {
  late int id;
  late String comment;
  late DateTime created;
  late int authorId;
  late String authorName;
  late String authorAvt;

  CommentModel(
      {required this.id,
      required this.comment,
      required this.created,
      required this.authorId,
      required this.authorName,
      required this.authorAvt});

  factory CommentModel.fromJson(Map<String, dynamic> data) {
    var crTime = DateTime.parse(data['created']);
    return CommentModel(
        id: data['id'],
        comment: data['comment'],
        created: crTime,
        authorId: data['poster']['id'],
        authorName: data['poster']['name'],
        authorAvt: data['poster']['avtlink']);
  }

  CommentModel.origin() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    comment = faker.lorem.sentences(5).toString();
    created = faker.date.dateTime(minYear: 2020, maxYear: 2021);

    authorId = faker.randomGenerator.integer(50);
    authorName = faker.person.name();
    authorAvt = faker.image.image(random: true);
  }
}
