import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/pages/signed_home/timeline/edit_comment.dart';

class CommentItem extends StatelessWidget {
  final CommentModel cmt;
  final void Function()? onDelete;
  const CommentItem({
    Key? key,
    required this.cmt,
    this.onDelete,
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
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onLongPress: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int userId = prefs.getInt('id') ?? 0;
          if (userId == cmt.authorId) {
            showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                      child: IntrinsicHeight(
                          child: Column(children: [
                    SizedBox(
                      height: 70,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        focusColor: Colors.grey,
                        onTap: () {
                          Navigator.of(_).pop();
                          Navigator.push(
                              context,
                              CustomPageRoute(EditComment(
                                cmt: cmt,
                              )));
                        },
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: Icon(CupertinoIcons.pencil),
                                )),
                            Expanded(
                                flex: 5, child: Text("Chinh sua binh luan")),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        focusColor: Colors.grey,
                        onTap: () {
                          Navigator.of(_).pop();
                          if (onDelete != null) onDelete!();
                        },
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: Icon(CupertinoIcons.trash),
                                )),
                            Expanded(flex: 5, child: Text("Xoa binh luan")),
                          ],
                        ),
                      ),
                    ),
                  ])));
                });
          }
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(imageUrl: cmt.authorAvt),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cmt.authorName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    CustomText(
                        text: cmt.comment,
                        textStyle: const TextStyle(fontSize: 16)),
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
        ),
      ),
    );
  }
}
