import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResColors.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 50,
              child: Row(
                children: const [
                  Expanded(
                    child: Icon(Icons.person),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text("Loi moi ket ban"),
                    flex: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: const NewlyFriend(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewlyFriend extends StatefulWidget {
  const NewlyFriend({Key? key}) : super(key: key);

  @override
  _NewlyFriendState createState() => _NewlyFriendState();
}

class _NewlyFriendState extends State<NewlyFriend> {
  List<CommentFaker> _friends = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 10; i++) {
      _friends.add(CommentFaker.origin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Ban be moi truy cap"),
          );
        }
        return Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ProfileAvatar(
                  imageUrl: _friends.elementAt(index - 1).author_avt,
                  isActive: true,
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(_friends.elementAt(index - 1).author_name),
                flex: 8,
              ),
            ],
          ),
        );
      },
      itemCount: _friends.length + 1,
    );
  }
}
