import 'package:bk_zalo/pages/signed_home/timeline/comment_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/post_model.dart';

class PostContainer extends StatefulWidget {
  final PostFaker post;
  const PostContainer({Key? key, required this.post}) : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  String timeAgo = '';

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    final now = DateTime.now();
    final different = now.difference(post.created);
    if (different.inSeconds <= 60) {
      timeAgo = 'just now ';
    } else if (different.inHours <= 24) {
      timeAgo = different.inHours.toString() + ' hour ago';
    } else if (different.inDays <= 7) {
      timeAgo = post.created.weekday.toString() +
          ' at ' +
          post.created.hour.toString() +
          ':' +
          post.created.minute.toString();
    } else if (different.inDays <= 365) {
      timeAgo = post.created.day.toString() +
          '/' +
          post.created.month.toString() +
          ' at ' +
          post.created.hour.toString() +
          ':' +
          post.created.minute.toString();
    } else {
      timeAgo = (now.year - post.created.year).toString() + ' year ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PostHeader(
                  post: widget.post,
                  timeAgo: timeAgo,
                ),
                const SizedBox(
                  height: 14.0,
                ),
                ExpandableText(
                  widget.post.described,
                  expandText: 'show more',
                  maxLines: 2,
                  linkColor: Colors.blue,
                ),
                widget.post.images.isNotEmpty
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      )
              ],
            ),
          ),
          widget.post.images.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CachedNetworkImage(imageUrl: widget.post.images.first),
                )
              : const SizedBox.shrink(),
          const Divider(),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.post.isLiked = !widget.post.isLiked;
                          if (widget.post.isLiked) {
                            widget.post.like++;
                          } else {
                            widget.post.like--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          widget.post.isLiked
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red[600],
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.post.like.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (ct) {
                            return CommentSheet();
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(widget.post.commment.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
    required this.post,
    required this.timeAgo,
  }) : super(key: key);

  final PostFaker post;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(imageUrl: post.author_avt),
        const SizedBox(
          width: 14.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author_name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Text(
                timeAgo,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ct) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: const [
                                    Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Icon(Icons.lock_outlined),
                                        )),
                                    Expanded(
                                        flex: 6,
                                        child: Text("Chinh sua quyen xem")),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: const [
                                    Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Icon(
                                              CupertinoIcons.pencil_outline),
                                        )),
                                    Expanded(
                                        flex: 6,
                                        child: Text("Chinh sua quyen xem")),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  onTap: () async {
                                    Navigator.of(ct).pop();
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    showDialog(
                                        context: context,
                                        builder: (ct) {
                                          return AlertDialog(
                                            content: const Text(
                                                "Ban co the chinh sua bai viet thay vi xoa no"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(ct);
                                                  },
                                                  child: const Text(
                                                    "Chinh sua",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.lightBlue),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(ct);
                                                  },
                                                  child: const Text(
                                                    "Xoa",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                            ],
                                          );
                                        });
                                  },
                                  focusColor: Colors.grey,
                                  child: Row(
                                    children: const [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Icon(CupertinoIcons.trash),
                                          )),
                                      Expanded(
                                          flex: 6,
                                          child: Text("Chinh sua quyen xem")),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.more_horiz)),
      ],
    );
  }
}
