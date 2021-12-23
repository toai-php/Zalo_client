import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/pages/signed_home/timeline/create_post.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post_screen.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with AutomaticKeepAliveClientMixin<TimelinePage> {
  List<PostFaker> list = [];
  final _scrollController = ScrollController(keepScrollOffset: false);
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        getList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      body: list.isEmpty
          ? const LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: refresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: CreatePostContainer(),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == list.length) {
                      return SizedBox(
                        height: 50,
                        width: size.width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    var data = list.elementAt(index);
                    return GestureDetector(
                      child: PostContainer(post: data),
                      onTap: () {
                        Navigator.push(
                            context,
                            CustomPageRoute(PostMain(
                              post: data,
                            )));
                      },
                    );
                  }, childCount: list.length + 1)),
                ],
              ),
            ),
    );
  }

  getList() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    for (int i = 0; i < 30; i++) {
      list.add(PostFaker.origin());
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    for (var element in list) {
      element.author_name = Faker().person.name();
    }
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
