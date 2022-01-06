import 'package:bk_zalo/api/api_service.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/models/conversation.dart';
import 'package:bk_zalo/pages/signed_home/message/conver_card.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    Key? key,
    required this.onNumMessage,
  }) : super(key: key);

  final ValueChanged<int> onNumMessage;

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isLoading = false;
  final List<ConversationModel> _list = [];
  final _api = APIService();

  getList() async {
    setState(() {
      isLoading = true;
    });
    final l = await _api.getListConver(0, 20);
    if (l.code == '1000') {
      _list.addAll(l.data);
      widget.onNumMessage(l.numNewMessages);
    } else {
      print("error in message");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemBuilder: (_, index) {
              if (index == _list.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Dễ dàng tìm kiếm và trò chuyện với bạn bè',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () {},
                          child: const Text("Tìm thêm bạn"))
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  ConverCard(
                    onQuit: () async {
                      _list.clear();
                      await getList();
                    },
                    conver: _list.elementAt(index),
                    key: UniqueKey(),
                  ),
                  index == _list.length - 1
                      ? const Divider(
                          height: 0,
                          thickness: 1,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(left: 90),
                          child: Divider(
                            height: 0,
                            thickness: 1,
                          ),
                        )
                ],
              );
            },
            itemCount: _list.length + 1,
            shrinkWrap: true,
          );
  }
}
