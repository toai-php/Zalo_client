import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/pages/signed_home/contact/friend_request.dart';
import 'package:bk_zalo/pages/signed_home/message/chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/user_model.dart';
import 'package:bk_zalo/res/colors.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _list = <Map>[];
  final _friend = <Map>[];
  bool isLoading = false;
  bool netWorkFail = false;

  getData() async {
    setState(() {
      isLoading = true;
      netWorkFail = false;
    });
    final _api = APIService();
    final res = await _api.getListFriend();
    if (res.code == '1000') {
      for (int i = 0; i < res.data.length; i++) {
        var map = {};
        map['name'] = res.data[i];
        map['first'] = res.data[i].name[0];
        _list.add(map);
      }
      _list.sort((m1, m2) {
        var r = m1["first"].compareTo(m2["first"]);
        if (r != 0) return r;
        return m1["name"].name.compareTo(m2["name"].name);
      });
      var newf =
          groupBy(_list, (Map obj) => obj['first']).map((k, v) => MapEntry(
              k,
              v.map((item) {
                item.remove('first');
                return item;
              }).toList()));
      newf.forEach((key, value) {
        for (int i = 0; i < value.length; i++) {
          var map = {};
          if (i == 0) map['first'] = key.toString();
          map['data'] = value[i]['name'];
          _friend.add(map);
        }
      });
    } else {
      netWorkFail = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (netWorkFail) {
      return Center(
        child: ElevatedButton(
          child: const Text('Re try'),
          onPressed: () {
            _list.clear();
            _friend.clear();
            getData();
          },
        ),
      );
    }
    return Container(
      color: ResColors.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                color: Colors.white,
                height: 70,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.grey,
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      Navigator.push(
                          context, CustomPageRoute(const FriendRequestPage()));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: const Icon(
                              CupertinoIcons.person_2_fill,
                              color: Colors.white,
                            ),
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                          ),
                          flex: 2,
                        ),
                        const Expanded(
                          child: Text(
                            "Lời mời kết bạn",
                            style: TextStyle(fontSize: 16),
                          ),
                          flex: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: const NewlyFriend(),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: ListFriend(
                  friend: _friend,
                ),
                color: Colors.white,
              ),
            ),
            Padding(
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
                                  borderRadius: BorderRadius.circular(20)))),
                      onPressed: () {},
                      child: const Text("Tìm thêm bạn"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewlyFriend extends StatefulWidget {
  const NewlyFriend({Key? key}) : super(key: key);

  @override
  _NewlyFriendState createState() => _NewlyFriendState();
}

class _NewlyFriendState extends State<NewlyFriend> {
  final List<UserModel> _friends = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_friends.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Bạn bè mới truy cập",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffBABABA)),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            height: 50,
            child: const Center(
              child: Text(
                "Khong co ban be nao online",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Bạn bè mới truy cập",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: ProfileAvatar(
                  imageUrl: _friends.elementAt(index - 1).avtlink,
                  isActive: true,
                ),
                flex: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(_friends.elementAt(index - 1).name),
                ),
                flex: 8,
              ),
            ],
          ),
        );
      },
      itemCount: _friends.length + 1,
    );
  }
}

class ListFriend extends StatefulWidget {
  const ListFriend({
    Key? key,
    required this.friend,
  }) : super(key: key);
  final List<Map> friend;

  @override
  _ListFriendState createState() => _ListFriendState();
}

class _ListFriendState extends State<ListFriend> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Tất cả bạn bè",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        }

        var person = widget.friend[index - 1]['data'];
        var first = widget.friend[index - 1]['first'];
        if (first != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Divider(
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
                child: Text(first),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(CustomPageRoute(ChatScreen(
                      partnerId: person.id,
                      partnerName: person.name,
                      converId: person.room,
                      key: UniqueKey(),
                      onQuit: () {},
                    )));
                  },
                  splashFactory: NoSplash.splashFactory,
                  focusColor: Colors.grey,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                CachedNetworkImageProvider(person.avtlink),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              person.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          flex: 9,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(CustomPageRoute(ChatScreen(
                  partnerId: person.id,
                  partnerName: person.name,
                  converId: person.room,
                  key: UniqueKey(),
                  onQuit: () {},
                )));
              },
              splashFactory: NoSplash.splashFactory,
              focusColor: Colors.grey,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ProfileAvatar(
                        radius: 25,
                        imageUrl: person.avtlink,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          person.name,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      flex: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      itemCount: widget.friend.length + 1,
    );
  }
}
