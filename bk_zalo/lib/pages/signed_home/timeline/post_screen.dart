import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/models/post_model.dart';

class PostMain extends StatefulWidget {
  const PostMain({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostFaker post;

  @override
  _PostMainState createState() => _PostMainState();
}

class _PostMainState extends State<PostMain> {
  String timeAgo = '';
  final List<CommentFaker> _listCmt = [];

  getList() async {
    await Future.delayed(const Duration(seconds: 1));
    for (int i = 0; i < widget.post.commment; i++) {
      _listCmt.add(CommentFaker.origin());
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getList();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Binh luan"),
      ),
      body: RefreshIndicator(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
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
                        child: CachedNetworkImage(
                            imageUrl: widget.post.images.first),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 40,
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
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Co ${widget.post.commment} binh luan. Ban chi co the xem binh luan cua nhung nguoi la ban be."),
                ),
                const Divider(
                  thickness: 0.8,
                ),
                _listCmt.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                      )
                    : LinearProgressIndicator(),
              ],
            ),
          ),
          onRefresh: _onRefresh),
      bottomSheet: SizedBox(
        height: 50,
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(Icons.emoji_emotions_outlined),
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
              Expanded(
                child: TextField(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(Icons.photo_library),
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: SizedBox(
                    child: Icon(Icons.video_collection),
                    width: 30,
                    height: 30,
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {}
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
      ],
    );
  }
}
