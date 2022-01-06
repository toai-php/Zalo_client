import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/pages/signed_home/timeline/edit_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/components/video_player.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/pages/signed_home/timeline/comment_sheet.dart';

class PostContainer extends StatefulWidget {
  final PostModel post;
  final ValueChanged<int> update;
  const PostContainer({
    Key? key,
    required this.post,
    required this.update,
  }) : super(key: key);

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
    } else if (different.inMinutes < 60) {
      timeAgo = different.inMinutes.toString() + ' minutes ago';
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
                  onTap: () {
                    widget.update(widget.post.id);
                  },
                ),
                const SizedBox(
                  height: 14.0,
                ),
                CustomText(
                    text: widget.post.described,
                    textStyle: const TextStyle(fontSize: 17)),
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
                  child: _listImage(),
                )
              : const SizedBox.shrink(),
          widget.post.video.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MyVideoPlayer(url: widget.post.video),
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
                      onTap: () async {
                        final _api = APIService();
                        var responce = await _api.like(widget.post.id);
                        if (responce.code == '1000') {
                          widget.post.isLiked = !widget.post.isLiked;
                          widget.post.like = responce.data['like'];
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Kiem tra lai internet"),
                          ));
                        }
                        setState(() {});
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
                          isScrollControlled: true,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.6,
                              child: CommentSheet(
                                post: widget.post,
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble_text,
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

  Widget _listImage() {
    if (widget.post.images.length == 1) {
      return CachedNetworkImage(imageUrl: widget.post.images.first);
    }
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: widget.post.images.length > 1 ? 198 : 398,
              height: widget.post.images.length > 3 ? 198 : 398,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.post.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (widget.post.images.length > 1)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 198,
                height: widget.post.images.length > 2 ? 198 : 398,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[1]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (widget.post.images.length > 2)
            Align(
              alignment: widget.post.images.length > 3
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: Container(
                width: 198,
                height: 198,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[2]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (widget.post.images.length > 3)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 198,
                height: 198,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[3]),
                    fit: BoxFit.cover,
                  ),
                ),
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
    required this.onTap,
  }) : super(key: key);

  final PostModel post;
  final String timeAgo;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(imageUrl: post.authorAvt),
        const SizedBox(
          width: 14.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
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
                                        flex: 5,
                                        child: Text("Chinh sua quyen xem")),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  focusColor: Colors.grey,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CustomPageRoute(EditPost(
                                          post: post,
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
                                          flex: 5,
                                          child: Text("Chinh sua bai dang")),
                                    ],
                                  ),
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
                                                  onPressed: () async {
                                                    Navigator.pop(ct);
                                                    final _api = APIService();
                                                    _api
                                                        .deletePost(post.id)
                                                        .then((value) {
                                                      if (value.code ==
                                                          '1000') {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "Xoa thanh cong"),
                                                        ));
                                                        onTap();
                                                      } else if (value.code ==
                                                          '9995') {
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Phien dang nhap da het"),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pushReplacementNamed(
                                                                            context,
                                                                            'login');
                                                                      },
                                                                      child: const Text(
                                                                          "OK")),
                                                                ],
                                                              );
                                                            });
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "Khong the ket noi den server"),
                                                        ));
                                                      }
                                                    });
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
                                          flex: 5, child: Text("Xoa bai dang")),
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

class PostContainer2 extends StatefulWidget {
  final PostModel post;
  final ValueChanged<int> update;
  const PostContainer2({
    Key? key,
    required this.post,
    required this.update,
  }) : super(key: key);

  @override
  State<PostContainer2> createState() => _PostContainer2State();
}

class _PostContainer2State extends State<PostContainer2> {
  String timeAgo = '';

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    timeAgo = widget.post.created.day.toString() +
        ' tháng ' +
        widget.post.created.month.toString() +
        ', ' +
        widget.post.created.year.toString();
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
                Wrap(
                  children: [
                    Container(
                      color: const Color(0xffE1E4EB),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        timeAgo,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14.0,
                ),
                CustomText(
                    text: widget.post.described,
                    textStyle: const TextStyle(fontSize: 17)),
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
                  child: _listImage(),
                )
              : const SizedBox.shrink(),
          widget.post.video.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MyVideoPlayer(url: widget.post.video),
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
                      onTap: () async {
                        final _api = APIService();
                        var responce = await _api.like(widget.post.id);
                        if (responce.code == '1000') {
                          widget.post.isLiked = !widget.post.isLiked;
                          widget.post.like = responce.data['like'];
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Kiem tra lai internet"),
                          ));
                        }
                        setState(() {});
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
                          isScrollControlled: true,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.6,
                              child: CommentSheet(
                                post: widget.post,
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble_text,
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

  Widget _listImage() {
    if (widget.post.images.length == 1) {
      return CachedNetworkImage(imageUrl: widget.post.images.first);
    }
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: widget.post.images.length > 1 ? 198 : 398,
              height: widget.post.images.length > 3 ? 198 : 398,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.post.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (widget.post.images.length > 1)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 198,
                height: widget.post.images.length > 2 ? 198 : 398,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[1]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (widget.post.images.length > 2)
            Align(
              alignment: widget.post.images.length > 3
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: Container(
                width: 198,
                height: 198,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[2]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (widget.post.images.length > 3)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 198,
                height: 198,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.images[3]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
