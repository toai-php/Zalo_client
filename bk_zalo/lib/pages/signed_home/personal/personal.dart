import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/components/profile_page.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late final String user_name;
  late final String user_avt;
  late final int user_id;
  bool isLoading = false;

  void changeState() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_name = prefs.getString('name') ?? "User";
    user_avt = prefs.getString('avtlink') ??
        "http://192.168.1.12:3000/img/default.jpg";
    user_id = prefs.getInt('id') ?? 0;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    changeState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Container(
              color: Colors.white,
              height: 90,
              child: isLoading
                  ? Container()
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.grey,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () async {
                          final _api = APIService();
                          final user = await _api.getProfile(user_id, null);
                          if (user.code == '1000') {
                            Navigator.of(context).push(
                                CustomPageRoute(ProfilePage(profile: user)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('error')));
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: ProfileAvatar(
                                imageUrl: user_avt,
                                radius: 25.0,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user_name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Xem trang cá nhân",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ],
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
            color: Colors.white,
            height: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.grey,
                splashFactory: NoSplash.splashFactory,
                onTap: () {},
                child: Row(
                  children: const [
                    Expanded(
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.blue,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Text(
                        "Tài khoản và bảo mật",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      flex: 8,
                    ),
                    Expanded(
                      child: Center(child: Icon(Icons.arrow_forward_ios)),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.8,
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.grey,
                splashFactory: NoSplash.splashFactory,
                onTap: () {},
                child: Row(
                  children: const [
                    Expanded(
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.blue,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Text(
                        "Quyền riêng tư",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      flex: 8,
                    ),
                    Expanded(
                      child: Center(child: Icon(Icons.arrow_forward_ios)),
                      flex: 1,
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
