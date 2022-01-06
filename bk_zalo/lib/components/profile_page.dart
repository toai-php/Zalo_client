// ignore_for_file: unnecessary_new

import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post_screen.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/models/profile_model.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final ProfileModel profile;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  bool show = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        setState(() {
          show = true;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ResColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: show ? Colors.white : Colors.transparent,
        elevation: show ? null : 0,
        actions: [
          Icon(
            Icons.more_horiz,
            color: show ? Colors.black : Colors.white,
          )
        ],
        title: show
            ? Row(
                children: [
                  ProfileAvatar(imageUrl: widget.profile.userAvt),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.profile.userName,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )
            : null,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: show ? Colors.black : Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://www.popsci.com/uploads/2020/06/05/3NIEQB3SFVCMNHH6MHZ42FO6PA.jpg?auto=webp'),
                  fit: BoxFit.cover,
                ),
              ),
              margin: const EdgeInsets.only(bottom: 100),
              height: 250,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: const FractionalOffset(0.5, 2.9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 4.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.profile.userAvt),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.profile.userName,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          chooseWidget(),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            if (index == widget.profile.data.length) {
              return const SizedBox(
                height: 100,
              );
            }
            var data = widget.profile.data.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(left: 25, right: 10, top: 30),
              child: GestureDetector(
                child: PostContainer2(post: data, update: _update),
                onTap: () {
                  Navigator.push(
                      context,
                      CustomPageRoute(PostMain(
                        post: data,
                      )));
                },
              ),
            );
          }, childCount: widget.profile.data.length + 1)),
        ],
      ),
    );
  }

  void _update(int id) {
    widget.profile.data.removeWhere((element) {
      if (element.id == id) {
        return true;
      }
      return false;
    });
    setState(() {});
  }

  chooseWidget() {
    if (widget.profile.type == 3) {
      return SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 25, right: 10),
          child: Row(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                  child: Text('Bạn đang nghĩ gì'),
                ),
                flex: 7,
              ),
              Expanded(
                child: Icon(
                  Icons.photo,
                  color: Colors.green,
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      );
    } else if (widget.profile.type == 0) {
      return SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 12),
                child: Text(
                    'Kết bạn với ' +
                        widget.profile.userName +
                        ' ngay để cùng tạo nên những cuộc trò chuyện thú vị và đáng nhớ!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Nhắn tin")),
                    ElevatedButton(
                        onPressed: () async {
                          final _api = APIService();
                          final res = await _api
                              .setRequestFriend(widget.profile.userId);
                          if (res.code == '1000') {
                            setState(() {
                              widget.profile.type == 2;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Gửi kết bạn thành công')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Có lỗi sảy ra')));
                          }
                        },
                        child: const Text("Kết bạn")),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
