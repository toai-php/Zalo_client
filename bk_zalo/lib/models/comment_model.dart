import 'package:faker/faker.dart';

class CommentFaker {
  late int id;
  late String comment;
  late DateTime created;
  late int author_id;
  late String author_name;
  late String author_avt;
  late bool isBlocked;

  CommentFaker.origin() {
    var faker = Faker();
    id = faker.randomGenerator.integer(50);
    comment = faker.lorem.sentences(5).toString();
    created = faker.date.dateTime(minYear: 2020, maxYear: 2021);

    author_id = faker.randomGenerator.integer(50);
    author_name = faker.person.name();
    author_avt = faker.image.image(random: true);
    isBlocked = faker.randomGenerator.boolean();
  }
}
