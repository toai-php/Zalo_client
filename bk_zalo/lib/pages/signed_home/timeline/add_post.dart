import 'dart:math';
import 'dart:typed_data';

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/bottom_sheet.dart';
import 'package:bk_zalo/components/emoji_picker.dart';
import 'package:bk_zalo/components/media_list.dart';
import 'package:bk_zalo/components/textfield_style.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _focusNode = FocusNode();
  final _controller = BottomSheetController();
  final TextEditingController _textController = TextFieldColorizer();
  var index = 0;
  bool tfOffstage = false;
  List<AssetEntity> images = [];
  List<AssetEntity> video = [];

  bool get canPost => (_textController.text.isNotEmpty ||
      images.isNotEmpty ||
      video.isNotEmpty);

  @override
  void initState() {
    super.initState();
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
    api.addPost(images, vid, _textController.text).then((value) {});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
                    _buildMedia(),
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

  void _imageUpdate(AssetEntity entity) {
    if (images.contains(entity)) {
      images.remove(entity);
    } else {
      images.add(entity);
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

  Widget _buildMedia() {
    if (video.isNotEmpty) {
      AssetEntity asset = video.first;
      return FutureBuilder(
        future: asset.thumbDataWithSize(400, 400), //resolution of thumbnail
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
    } else if (images.isNotEmpty) {
      List<Widget> temp = [];
      for (final asset in images) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(400, 400), //resolution of thumbnail
            builder:
                (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        );
      }
      return SizedBox(
        width: 400,
        height: 400,
        child: Stack(
          children: [
            Positioned(
              child: temp.first,
              top: 0,
              left: 0,
              width: temp.length > 1 ? 199 : 399,
              height: temp.length > 3 ? 199 : 399,
            ),
            if (temp.length > 1)
              Positioned(
                child: temp[1],
                top: 0,
                right: 0,
                width: 199,
                height: temp.length > 2 ? 199 : 399,
              ),
            if (temp.length > 2)
              Positioned(
                child: temp[2],
                bottom: 0,
                right: 0,
                width: 199,
                height: 199,
              ),
            if (temp.length > 3)
              Positioned(
                child: temp[3],
                bottom: 0,
                left: 0,
                width: 199,
                height: 199,
              ),
          ],
        ),
      );
    }
    return Container();
  }
}
