import 'dart:math';

import 'package:bk_zalo/components/comment_item.dart';
import 'package:bk_zalo/components/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/components/emoji_picker.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/components/textfield_style.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/res/colors.dart';

class PostMain extends StatefulWidget {
  const PostMain({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  _PostMainState createState() => _PostMainState();
}

class _PostMainState extends State<PostMain> {
  String timeAgo = '';
  final List<CommentModel> _listCmt = [];
  final _api = APIService();
  int index = 0;
  int count = 20;
  bool isEndData = false;

  getList() async {
    var _l = await _api.getComment(widget.post.id, index, count);
    if (_l.code == '1000') {
      _listCmt.addAll(_l.data);
      index += _l.data.length;
      if (_l.data.length < count) isEndData = true;
    } else if (_l.code == '9994') {
      isEndData = true;
    } else if (_l.code == '9995') {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Phien dang nhap da het"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                    child: const Text("OK")),
              ],
            );
          });
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
        title: const Text("Bình luận"),
        leading: IconButton(
          onPressed: () {
            widget.post.commment = _listCmt.length;
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      CustomText(
                          text: widget.post.described,
                          textStyle: const TextStyle(fontSize: 16)),
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
                  height: 40,
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
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Co ${_listCmt.length} binh luan. Ban chi co the xem binh luan cua nhung nguoi la ban be."),
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

                          return CommentItem(cmt: _listCmt.elementAt(index));
                        },
                        itemCount: _listCmt.length + 1,
                      )
                    : Container(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InputContainer(
              onSend: (text) async {
                var response = await _api.setComment(widget.post.id, text);
                if (response.code == '1000') {
                  index = 0;
                  isEndData = false;
                  _listCmt.clear();
                  setState(() {});
                  getList();
                }
              },
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

class InputContainer extends StatefulWidget {
  const InputContainer({
    Key? key,
    this.onSend,
  }) : super(key: key);
  final void Function(String text)? onSend;

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  final TextEditingController _textController = TextFieldColorizer();
  final _focusNode = FocusNode();

  bool isClose = true;
  bool get canSubmit => _textController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isClose = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isClose == false) {
          setState(() {
            isClose = true;
          });
          return false;
        }
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: ResColors.backgroundColor,
              border: Border(
                top: BorderSide(width: 0.8, color: Colors.grey),
              ),
            ),
            height: 60,
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () async {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                          await Future.delayed(
                              const Duration(milliseconds: 200));
                        }
                        setState(() {
                          isClose = !isClose;
                        });
                      },
                      child: const Icon(
                        Icons.emoji_emotions_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      showCursor: true,
                      controller: _textController,
                      focusNode: _focusNode,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nhập bình luận",
                          hintStyle: TextStyle(fontSize: 19)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: canSubmit
                          ? () {
                              if (_textController.text.isEmpty) {
                                return;
                              }
                              String text = _textController.text;
                              _textController.clear();

                              if (widget.onSend != null) {
                                widget.onSend!(text);
                              }
                            }
                          : null,
                      child: SizedBox(
                        child: Icon(
                          Icons.send,
                          color: canSubmit ? Colors.blue : Colors.grey,
                        ),
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            width: double.maxFinite,
            height: isClose ? 0 : 250,
            color: Colors.white,
            child: EmojiList(
              onPick: (emoji) {
                if (_textController.text.endsWith(' ') ||
                    _textController.text.isEmpty) {
                  insertText(emoji, _textController);
                } else {
                  insertText(' ' + emoji, _textController);
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void insertText(String insert, TextEditingController controller) {
    final int cursorPos = controller.selection.base.offset;
    controller.value = controller.value.copyWith(
        text: controller.text
            .replaceRange(max(cursorPos, 0), max(cursorPos, 0), insert),
        selection: TextSelection.fromPosition(
            TextPosition(offset: max(cursorPos, 0) + insert.length)));
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
    required this.post,
    required this.timeAgo,
  }) : super(key: key);

  final PostModel post;
  final String timeAgo;

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
      ],
    );
  }
}
