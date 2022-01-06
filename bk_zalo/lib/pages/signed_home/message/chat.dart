import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/models/chat_model.dart';
import 'package:bk_zalo/pages/signed_home/message/message_card.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.partnerId,
    required this.converId,
    required this.partnerName,
    required this.onQuit,
  }) : super(key: key);
  final int partnerId;
  final int converId;
  final String partnerName;
  final void Function() onQuit;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _list = <Map>[];
  int index = 0;
  int count = 20;
  final _api = APIService();

  io.Socket socket = io.io('http://192.168.1.12:3000', <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });

  void addMessage(ChatModel model) {
    if (model.id == -1) {
      return;
    }
    var map = {};
    map['model'] = model;
    map['type'] = model.senderId == widget.partnerId ? 0 : 1;
    map['lead'] = 2;
    if (_list.isNotEmpty) {
      bool dif = (_list.last['model'].created.year == model.created.year) &&
          (_list.last['model'].created.month == model.created.month) &&
          (_list.last['model'].created.day == model.created.day);
      if (dif) {
        map['lead'] = 1;
        if (_list.first['type'] == map['type']) {
          map['lead'] = 0;
        }
      }
    }

    _list.add(map);
    if (mounted) {
      setState(() {});
    }
  }

  void connect() async {
    socket.connect();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id') ?? -1;
    socket.emit('joinchat', id);
    socket.on('onmessage', (data) {
      addMessage(ChatModel.fromSocket(data));
    });
    await getList();
  }

  getList() async {
    final li = await _api.getListChat(widget.converId, index, count);
    if (li.code == '1000') {
      index += li.data.length;
      addToList(li.data);
    } else {
      print("eoor in chat");
    }
    setState(() {});
  }

  addToList(List<ChatModel> list) {
    list.sort((a, b) {
      return a.created.compareTo(b.created);
    });
    for (int i = 0; i < list.length; i++) {
      var map = {};
      map['model'] = list.elementAt(i);
      map['type'] = list.elementAt(i).senderId == widget.partnerId ? 0 : 1;
      map['lead'] = 2;
      if (_list.isNotEmpty) {
        bool dif = (_list.last['model'].created.year ==
                list.elementAt(i).created.year) &&
            (_list.last['model'].created.month ==
                list.elementAt(i).created.month) &&
            (_list.last['model'].created.day == list.elementAt(i).created.day);
        if (dif) {
          map['lead'] = 1;
          if (_list.last['type'] == map['type']) {
            map['lead'] = 0;
          }
        }
      }
      _list.add(map);
    }
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xff3878DC), Color(0xFF02bbfb)]),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            widget.onQuit();
            socket.disconnect();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
          iconSize: 30,
          color: Colors.white,
          splashRadius: 30,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.partnerName,
              textAlign: TextAlign.left,
            ),
            const Text(
              "Truy cập 1 giờ trước",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffA7E5FF)),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(CupertinoIcons.list_bullet))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xffE2E9F1),
              child: ListView.builder(
                itemBuilder: (_, ind) {
                  final index = _list.length - 1 - ind;
                  if (_list.elementAt(index)['lead'] == 2) {
                    String date = DateFormat('hh:mm, dd/MM/yyyy')
                        .format(_list.elementAt(index)['model'].created);
                    if (_list.elementAt(index)['type'] == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 8, right: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xffB4B9BD)),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                            OwnMessage(
                              chat: _list.elementAt(index)['model'],
                              key: UniqueKey(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 8, right: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xffB4B9BD)),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                            SenderMessage(
                              chat: _list.elementAt(index)['model'],
                              isLead: true,
                              key: UniqueKey(),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    bool isLead = (_list.elementAt(index)['lead'] == 1);
                    if (_list.elementAt(index)['type'] == 1) {
                      return Padding(
                        padding: isLead
                            ? const EdgeInsets.only(top: 12)
                            : EdgeInsets.zero,
                        child: OwnMessage(
                            key: UniqueKey(),
                            chat: _list.elementAt(index)['model']),
                      );
                    } else {
                      return Padding(
                        padding: isLead
                            ? const EdgeInsets.only(top: 12)
                            : EdgeInsets.zero,
                        child: SenderMessage(
                          key: UniqueKey(),
                          chat: _list.elementAt(index)['model'],
                          isLead: isLead,
                        ),
                      );
                    }
                  }
                },
                itemCount: _list.length,
                reverse: true,
                padding: const EdgeInsets.only(bottom: 10),
              ),
            ),
          ),
          IntrinsicHeight(
            child: InputContainer(
              onSend: (text) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int id = prefs.getInt('id') ?? -1;
                socket.emit('send', {
                  'room_id': widget.converId,
                  'sender': {'id': id},
                  'receiver': {'id': widget.partnerId},
                  'created': DateTime.now().toIso8601String(),
                  'content': text
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
