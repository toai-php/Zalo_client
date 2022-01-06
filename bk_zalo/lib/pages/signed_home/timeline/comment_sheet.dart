import 'package:bk_zalo/components/comment_item.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/models/comment_model.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post_screen.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    Key? key,
    required this.post,
  }) : super(key: key);
  final PostModel post;

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
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
    widget.post.commment = _listCmt.length;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Bình luận",
          style: TextStyle(color: Colors.blue, fontSize: 16),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
              ))
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ct, index) {
              if (index >= _listCmt.length) {
                return const SizedBox(
                  height: 50,
                );
              }

              return CommentItem(
                cmt: _listCmt.elementAt(index),
                onDelete: () {
                  final _api = APIService();
                  _api
                      .deleteCmt(widget.post.id, _listCmt.elementAt(index).id)
                      .then((value) {
                    if (value.code == '1000') {
                      _listCmt.removeAt(index);
                      widget.post.commment = _listCmt.length;
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No internet")));
                    }
                  });
                },
              );
            },
            itemCount: _listCmt.length + 1,
          ),
          Align(
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
          )
        ],
      ),
    );
  }
}
