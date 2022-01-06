import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/icon/my_flutter_app_icons.dart';
import 'package:bk_zalo/pages/signed_home/contact/add_friend.dart';
import 'package:bk_zalo/pages/signed_home/contact/contact.dart';
import 'package:bk_zalo/pages/signed_home/message/message.dart';
import 'package:bk_zalo/pages/signed_home/personal/personal.dart';
import 'package:bk_zalo/pages/signed_home/personal/setting_page.dart';
import 'package:bk_zalo/pages/signed_home/timeline/time_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final _pageViewController = PageController();

  int activePage = 0;
  int numMessage = 0;

  void changeNumMessage(int n) {
    setState(() {
      numMessage = n;
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
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
          onPressed: () {},
          icon: const Icon(
            Icons.search_outlined,
          ),
          iconSize: 30,
          color: Colors.white,
          splashRadius: 30,
        ),
        title: GestureDetector(
          child: Text(
            AppLocalizations.of(context)!.search_title,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Color(0xFF86C7FF), fontSize: 17),
          ),
        ),
        actions: _action(activePage),
      ),
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          MessagePage(
            onNumMessage: changeNumMessage,
          ),
          const ContactPage(),
          const TimelinePage(),
          const PersonalPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            activePage = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activePage,
        onTap: (index) {
          _pageViewController.jumpToPage(index);
        },
        backgroundColor: const Color(0xffFAFBFD),
        selectedItemColor: const Color(0xff1194FF),
        unselectedItemColor: const Color(0xff494B4A),
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(MyFlutterApp.z_message),
                Positioned(
                    right: -10,
                    top: -9,
                    child: Container(
                      width: 20,
                      height: 17,
                      child: numMessage > 0
                          ? Center(
                              child: Text(
                                numMessage < 5 ? numMessage.toString() : 'N',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            )
                          : null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: numMessage > 0
                              ? const Color(0xffFE5051)
                              : Colors.transparent),
                    ))
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(MyFlutterApp.z_message2),
                Positioned(
                    right: -10,
                    top: -9,
                    child: Container(
                      width: 20,
                      height: 17,
                      child: numMessage > 0
                          ? Center(
                              child: Text(
                                numMessage < 5 ? numMessage.toString() : 'N',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            )
                          : null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: numMessage > 0
                              ? const Color(0xffFE5051)
                              : Colors.transparent),
                    ))
              ],
            ),
            label: AppLocalizations.of(context)!.message_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              MyFlutterApp.contact,
            ),
            activeIcon: const Icon(MyFlutterApp.contact2),
            label: AppLocalizations.of(context)!.contact_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              MyFlutterApp.icons8_clock,
            ),
            activeIcon: const Icon(MyFlutterApp.icons8_clock2),
            label: AppLocalizations.of(context)!.timeline_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            activeIcon: const Icon(CupertinoIcons.person_fill),
            label: AppLocalizations.of(context)!.person_page,
          ),
        ],
      ),
    );
  }

  List<Widget> _action(int index) {
    if (index == 0) {
      return [
        IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add)),
      ];
    }
    if (index == 1) {
      return [
        IconButton(
            onPressed: () {
              Navigator.push(context, CustomPageRoute(const AddFriendPage()));
            },
            icon: const Icon(Icons.person_add_alt_1)),
      ];
    }
    if (index == 2) {
      return [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.add_photo_alternate)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
      ];
    }
    return [
      IconButton(
          onPressed: () {
            Navigator.push(context, CustomPageRoute(const Settings()));
          },
          icon: const Icon(Icons.settings)),
    ];
  }
}
