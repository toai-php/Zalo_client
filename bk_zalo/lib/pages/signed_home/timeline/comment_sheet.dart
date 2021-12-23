import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({Key? key}) : super(key: key);

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final List<CommentFaker> _listCmt = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 10; i++) {
      _listCmt.add(CommentFaker.origin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Icon(
            Icons.ac_unit,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (ct, index) {
          if (index >= _listCmt.length) {
            return const SizedBox(
              height: 50,
            );
          }
          if (_listCmt.elementAt(index).isBlocked) {
            return Container();
          }
          return _Comment(cmt: _listCmt.elementAt(index));
        },
        itemCount: _listCmt.length + 1,
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  final CommentFaker cmt;
  const _Comment({
    Key? key,
    required this.cmt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String timeAgo = '';
    final now = DateTime.now();
    final different = now.difference(cmt.created);
    if (different.inSeconds <= 60) {
      timeAgo = 'just now ';
    } else if (different.inHours <= 24) {
      timeAgo = different.inHours.toString() + ' hour ago';
    } else if (different.inDays <= 7) {
      timeAgo = cmt.created.weekday.toString() +
          ' at ' +
          cmt.created.hour.toString() +
          ':' +
          cmt.created.minute.toString();
    } else if (different.inDays <= 365) {
      timeAgo = cmt.created.day.toString() +
          '/' +
          cmt.created.month.toString() +
          ' at ' +
          cmt.created.hour.toString() +
          ':' +
          cmt.created.minute.toString();
    } else {
      timeAgo = (now.year - cmt.created.year).toString() + ' year ago';
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(imageUrl: cmt.author_avt),
          const SizedBox(
            width: 14.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cmt.author_name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ExpandableText(
                  cmt.comment,
                  expandText: 'show more',
                  maxLines: 2,
                  linkColor: Colors.blue,
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Divider(
                  thickness: 0.8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
