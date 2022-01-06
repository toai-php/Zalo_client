import 'package:bk_zalo/icon/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/res/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xff3878DC), Color(0xFF02bbfb)]),
          ),
        ),
        title: const Text(
          "Cài đặt",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
      body: Container(
        color: ResColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SettingPiece(
                  icon: Icons.lock_outline,
                  iconColor: Colors.blue,
                  text: "Quyền riêng tư"),
              const SettingPiece(
                  icon: Icons.shield_outlined,
                  iconColor: Colors.lightGreen,
                  text: "Tài khoản và bảo mật"),
              const SizedBox(
                height: 8.0,
              ),
              SettingPiece(
                  icon: Icons.notifications_outlined,
                  iconColor: Colors.red.shade300,
                  text: "Thông báo"),
              SettingPiece(
                  icon: MyFlutterApp.z_message,
                  iconColor: Colors.blue.shade300,
                  text: "Tin nhắn"),
              SettingPiece(
                  icon: MyFlutterApp.icons8_clock,
                  iconColor: Colors.purple.shade300,
                  text: "Nhật ký"),
              SettingPiece(
                  icon: Icons.language_outlined,
                  iconColor: Colors.green.shade300,
                  text: "Ngôn ngữ"),
              const SettingPiece(
                  icon: Icons.info_outline,
                  iconColor: Colors.grey,
                  text: "Thông tin về Zalo"),
              const SizedBox(
                height: 8.0,
              ),
              SettingPiece(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ct) {
                          return AlertDialog(
                            content: const Text(
                              "Đăng xuất khỏi tài khoản này",
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ct);
                                  },
                                  child: const Text(
                                    "HỦY",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ct);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.clear();
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  child: const Text(
                                    "ĐĂNG XUẤT",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          );
                        });
                  },
                  icon: Icons.logout_outlined,
                  iconColor: Colors.grey,
                  text: "Đăng xuất"),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingPiece extends StatelessWidget {
  const SettingPiece({
    Key? key,
    this.onTap,
    required this.icon,
    required this.iconColor,
    required this.text,
  }) : super(key: key);

  final void Function()? onTap;
  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.grey,
          splashFactory: NoSplash.splashFactory,
          onTap: onTap ?? () {},
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  color: iconColor,
                ),
                flex: 2,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0.8,
                    ),
                  ],
                ),
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
