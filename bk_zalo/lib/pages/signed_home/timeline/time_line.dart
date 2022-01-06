import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/models/post_model.dart';
import 'package:bk_zalo/pages/signed_home/timeline/create_post.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post.dart';
import 'package:bk_zalo/pages/signed_home/timeline/post_screen.dart';
import 'package:flutter/material.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with AutomaticKeepAliveClientMixin<TimelinePage> {
  List<PostModel> list = [];
  final _scrollController = ScrollController(keepScrollOffset: false);
  bool loading = false;
  bool isEndData = false;
  final _api = APIService();
  int lastId = 0;
  int index = 0;
  int count = 20;

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
                        child: isEndData
                            ? const Center(
                                child: Text(
                                    "Kết bạn để tìm thấy nhiều bài viết hơn"),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      );
                    }
                    var data = list.elementAt(index);
                    return GestureDetector(
                      child: PostContainer(
                        post: data,
                        update: _update,
                      ),
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

  void _update(int id) {
    list.removeWhere((element) {
      if (element.id == id) {
        return true;
      }
      return false;
    });
    setState(() {});
  }

  getList() async {
    setState(() {
      loading = true;
    });
    var _l = await _api.getListPost(lastId, index, count);
    if (_l.code == '1000') {
      list.addAll(_l.data);
      lastId = _l.lastId;
      index += _l.data.length;
    } else if (_l.code == '9994') {
      setState(() {
        isEndData = true;
      });
    } else if (_l.code == '9995') {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Phien dang nhap da het"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("OK")),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Ket noi that bai"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(_);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> refresh() async {
    index = 0;
    lastId = 0;
    list.clear();
    await getList();
  }

  @override
  bool get wantKeepAlive => true;
}
