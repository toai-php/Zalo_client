import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/profile_page.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool get canSubmit => _textController.text.isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
        title: const Text('Thêm bạn'),
      ),
      body: Container(
        color: ResColors.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Thêm bạn bằng số điện thoại'),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      showCursor: true,
                      keyboardType: TextInputType.phone,
                      controller: _textController,
                      focusNode: _focusNode,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nhập số điện thoại",
                          hintStyle: TextStyle(fontSize: 19)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: canSubmit
                          ? () async {
                              if (_textController.text.isEmpty) {
                                return;
                              }
                              String text = _textController.text;
                              _textController.clear();
                              final _api = APIService();
                              final user = await _api.getProfile(null, text);
                              if (user.code == '1000') {
                                print('pass');
                                Navigator.of(context)
                                    .push(CustomPageRoute(ProfilePage(
                                  profile: user,
                                  key: UniqueKey(),
                                )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('error')));
                              }
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: canSubmit
                                ? Colors.blue.shade500
                                : Colors.blue.shade200),
                        child: Center(
                            child: Text(
                          'TÌM',
                          style: TextStyle(
                              color: canSubmit ? Colors.white : Colors.white30),
                        )),
                        width: 60,
                        height: 30,
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
