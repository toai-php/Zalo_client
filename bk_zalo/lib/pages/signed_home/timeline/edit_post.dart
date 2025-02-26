import 'dart:math';
import 'dart:typed_data';

import 'package:bk_zalo/components/emoji_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/bottom_sheet.dart';
import 'package:bk_zalo/components/media_list.dart';
import 'package:bk_zalo/components/textfield_style.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/res/colors.dart';

class EditPost extends StatefulWidget {
  const EditPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _focusNode = FocusNode();
  final _controller = BottomSheetController();
  final TextEditingController _textController = TextFieldColorizer();
  var index = 0;
  bool tfOffstage = false;
  late List<String> img = [];
  List<Uint8List> images = [];
  List<AssetEntity> video = [];
  final List<AssetEntity> _listImage = [];

  bool get canPost => (_textController.text.isNotEmpty ||
      images.isNotEmpty ||
      video.isNotEmpty);

  bool get didChange => (_textController.text != widget.post.described ||
      images.isNotEmpty ||
      video.isNotEmpty ||
      img.length != widget.post.images.length);

  @override
  void initState() {
    super.initState();
    img.addAll(widget.post.images);
    _textController.text = widget.post.described;
    _focusNode.addListener(() async {
      if (_focusNode.hasFocus) {
        await _controller.close();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addPost() async {
    final api = APIService();
    var vid = video.isEmpty ? null : video.first;
    List<int> _l = [];
    for (var i = 0; i < widget.post.images.length; i++) {
      if (img.contains(widget.post.images[i]) == false) _l.add(i);
    }
    int img_index = widget.post.images.length - _l.length;
    api
        .editPost(widget.post.id, _l.join('-'), img_index, _listImage, vid,
            _textController.text)
        .then((value) {
      if (value.code == '1000') {
        widget.post.described = value.data['described'];
        widget.post.like = value.data['like'];
        widget.post.commment = value.data['comment'];
        String host = "http://192.168.1.12:3000";

        List<String> _img = [];
        String _vid = "";

        List<dynamic> media = value.data['media'];
        if (media.isNotEmpty) {
          int i1 = media[0]['stt'];
          if (i1 == -1) {
            _vid = host + media[0]['link'];
          } else {
            for (int i = 0; i < media.length; i++) {
              _img.add(host + media[i]['link']);
            }
          }
        }
        widget.post.images = _img;
        widget.post.video = _vid;
        if (mounted) {
          setState(() {});
        }
      }
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext bcontext) {
    return Scaffold(
      backgroundColor: ResColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        leading: IconButton(
          onPressed: () {
            if (didChange) {
              showDialog(
                  context: bcontext,
                  builder: (_) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text(
                              'Chưa lưu bài đăng đã chỉnh sửa. Thoát khỏi trang này?',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Ở lại',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(_).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Thoát',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            Navigator.of(_).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            Navigator.of(bcontext).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              Navigator.of(bcontext).pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF4A4A4A),
        ),
        title: const Text(
          "All friend",
          style: TextStyle(color: Color(0xFF4A4A4A)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: canPost ? _addPost : null,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "POST",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      autocorrect: false,
                      controller: _textController,
                      cursorColor: const Color(0xFF848D94),
                      focusNode: _focusNode,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                      decoration: const InputDecoration(
                        hintText: "what's on your mind",
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    _buildMedia(MediaQuery.of(context).size.width - 30),
                  ],
                ),
              ),
            ),
          ),
          ExhibitionBottomSheet(
            controller: _controller,
            maxHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            minHeight: 250,
            childBuilder: (_sc) => IndexedStack(
              index: index,
              children: [
                GridGallery(
                  scrollCtr: index == 0 ? _sc : null,
                  type: RequestType.image,
                  update: _imageUpdate,
                ),
                GridGallery(
                  scrollCtr: index == 1 ? _sc : null,
                  type: RequestType.video,
                  update: _videoUpdate,
                ),
                EmojiList(
                  controller: index == 2 ? _sc : null,
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
              ],
            ),
            topWidget: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                          await _controller.close();
                        }
                        if (_controller.isAttached) {
                          if (_controller.isPanelClosed) {
                            setState(() {
                              index = 2;
                            });
                            await _controller.open();
                          } else {
                            if (index == 2) {
                              await _controller.close();
                            } else {
                              setState(() {
                                index = 2;
                              });
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.emoji_emotions_outlined),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: video.isNotEmpty
                          ? null
                          : () async {
                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                                await _controller.close();
                              }
                              if (_controller.isAttached) {
                                if (_controller.isPanelClosed) {
                                  setState(() {
                                    index = 0;
                                  });
                                  await _controller.open();
                                } else {
                                  if (index == 0) {
                                    await _controller.close();
                                  } else {
                                    setState(() {
                                      index = 0;
                                    });
                                  }
                                }
                              }
                            },
                      icon: const Icon(Icons.image_outlined),
                    ),
                    IconButton(
                      onPressed: images.isNotEmpty
                          ? null
                          : () async {
                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                                await _controller.close();
                              }
                              if (_controller.isAttached) {
                                if (_controller.isPanelClosed) {
                                  setState(() {
                                    index = 1;
                                  });
                                  await _controller.open();
                                } else {
                                  if (index == 1) {
                                    await _controller.close();
                                  } else {
                                    setState(() {
                                      index = 1;
                                    });
                                  }
                                }
                              }
                            },
                      icon: const Icon(Icons.video_collection_outlined),
                    ),
                  ],
                ),
              ),
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

  void _imageUpdate(AssetEntity entity) async {
    int cnt = images.length;
    for (final a in img) {
      if (a.isNotEmpty) cnt++;
    }
    if (cnt >= 4) return;
    var ig = await entity.thumbnailDataWithSize(const ThumbnailSize(400, 400));
    if (images.contains(ig)) {
      images.remove(ig);
      _listImage.remove(entity);
    } else {
      images.add(ig!);
      _listImage.add(entity);
    }
    setState(() {});
  }

  void _videoUpdate(AssetEntity entity) {
    if (video.contains(entity)) {
      video.remove(entity);
    } else {
      video.add(entity);
    }
    setState(() {});
  }

  Widget _buildMedia(double width) {
    if (video.isNotEmpty) {
      AssetEntity asset = video.first;
      return FutureBuilder(
        future: asset.thumbnailDataWithSize(
            const ThumbnailSize(400, 400)), //resolution of thumbnail
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int duration = asset.duration;
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                ),
                if (asset.type == AssetType.video)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        semanticLabel: duration.toString(),
                      ),
                    ),
                  ),
              ],
            );
          }
          return Container();
        },
      );
    } else if (images.isNotEmpty || img.isNotEmpty) {
      List<ImageProvider> temp = [];
      for (final asset in img) {
        if (temp.length < 4 && asset.isNotEmpty) {
          temp.add(CachedNetworkImageProvider(asset));
        }
      }
      for (final asset in images) {
        if (temp.length < 4) {
          temp.add(MemoryImage(asset));
        }
      }
      return SizedBox(
        width: width,
        height: width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: temp.length > 1 ? width / 2 : width,
                height: temp.length > 3 ? width / 2 : width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: temp[0],
                    fit: BoxFit.contain,
                  ),
                ),
                child: Align(
                  alignment: const FractionalOffset(0.95, 0.05),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.white),
                    child: GestureDetector(
                        onTap: () {
                          if (img.isNotEmpty) {
                            img.removeAt(0);
                          } else {
                            images.removeAt(0);
                            _listImage.removeAt(0);
                          }
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.close,
                          size: 10,
                        )),
                  ),
                ),
              ),
            ),
            if (temp.length > 1)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: width / 2,
                  height: temp.length > 2 ? width / 2 : width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: temp[1],
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Align(
                    alignment: const FractionalOffset(0.95, 0.05),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            if (img.length >= 2) {
                              img.removeAt(1);
                            } else {
                              int cnt = img.length;

                              images.removeAt(1 - cnt);
                              _listImage.removeAt(1 - cnt);
                            }
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.close,
                            size: 10,
                          )),
                    ),
                  ),
                ),
              ),
            if (temp.length > 2)
              Align(
                alignment: temp.length > 3
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: Container(
                  width: width / 2,
                  height: width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: temp[2],
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Align(
                    alignment: const FractionalOffset(0.95, 0.05),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            if (img.length >= 3) {
                              img.removeAt(2);
                            } else {
                              int cnt = img.length;

                              images.removeAt(2 - cnt);
                              _listImage.removeAt(2 - cnt);
                            }
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.close,
                            size: 10,
                          )),
                    ),
                  ),
                ),
              ),
            if (temp.length > 3)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: width / 2,
                  height: width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: temp[3],
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Align(
                    alignment: const FractionalOffset(0.95, 0.05),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            if (img.length == 4) {
                              img.removeAt(3);
                            } else {
                              int cnt = img.length;

                              images.removeAt(3 - cnt);
                              _listImage.removeAt(3 - cnt);
                            }
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.close,
                            size: 10,
                          )),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    return Container();
  }
}
