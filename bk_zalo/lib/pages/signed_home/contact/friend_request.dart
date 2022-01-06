import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/models/user_model.dart';
import 'package:flutter/material.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({Key? key}) : super(key: key);

  @override
  _FriendRequestPageState createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  bool isLoading = false;
  final List<UserModel> _list = [];

  getList() async {
    setState(() {
      isLoading = false;
    });
    final _api = APIService();
    final l = await _api.getListRequest();
    _list.addAll(l.data);
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xff3878DC), Color(0xFF02bbfb)]),
          ),
        ),
        title: const Text('Lời mời kết bạn'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Text(
                'Đã nhận: ' + _list.length.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: isLoading
                ? Container()
                : ListView.builder(
                    itemBuilder: (ct, index) {
                      return Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ProfileAvatar(
                                radius: 25,
                                imageUrl: _list[index].avtlink,
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  _list[index].name,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              flex: 8,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final _api = APIService();
                                  final res = await _api.setAcceptFriend(
                                      _list[index].id, 1);
                                  if (res.code == '1000') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Đã kết bạn')));
                                    _list.removeAt(index);
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Có lỗi sảy ra')));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.blue.shade500),
                                  child: const Center(
                                      child: Text(
                                    'Chấp nhận',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  width: 60,
                                  height: 30,
                                ),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final _api = APIService();
                                  final res = await _api.setAcceptFriend(
                                      _list[index].id, 0);
                                  if (res.code == '1000') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Đã từ chối')));
                                    _list.removeAt(index);
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Có lỗi sảy ra')));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.blue.shade100),
                                  child: const Center(
                                      child: Text(
                                    'Từ chối',
                                    style: TextStyle(color: Colors.black54),
                                  )),
                                  width: 60,
                                  height: 30,
                                ),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: _list.length,
                  ),
          ),
        ],
      ),
    );
  }
}
