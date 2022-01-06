import 'package:bk_zalo/models/comment_model.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/bottom_sheet.dart';
import 'package:bk_zalo/components/textfield_style.dart';
import 'package:bk_zalo/res/colors.dart';

class EditComment extends StatefulWidget {
  const EditComment({
    Key? key,
    required this.cmt,
  }) : super(key: key);

  final CommentModel cmt;

  @override
  _EditCommentState createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  final _focusNode = FocusNode();
  final _controller = BottomSheetController();
  final TextEditingController _textController = TextFieldColorizer();
  var index = 0;
  bool tfOffstage = false;

  bool get canPost => (_textController.text.isNotEmpty);

  bool get didChange => (_textController.text != widget.cmt.comment);

  @override
  void initState() {
    super.initState();

    _textController.text = widget.cmt.comment;
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
