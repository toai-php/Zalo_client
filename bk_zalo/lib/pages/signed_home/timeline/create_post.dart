import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/pages/signed_home/timeline/add_post.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostContainer extends StatefulWidget {
  const CreatePostContainer({Key? key}) : super(key: key);

  @override
  State<CreatePostContainer> createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  bool isLoading = false;
  late String avt;

  getUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    avt = prefs.getString('avtlink') ??
        'http://192.168.1.12:3000/img/default.jpg';
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ProfileAvatar(imageUrl: avt),
                    ),
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddPost()));
                        },
                        child: const Text(
                          "What on your mind ...",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).dividerColor),
                            right: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).dividerColor),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.green,
                          ),
                          label: const Text("Photo"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).dividerColor),
                            right: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).dividerColor),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.videocam,
                            color: Colors.red,
                          ),
                          label: const Text("Video"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).dividerColor),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_album_sharp,
                          ),
                          label: const Text("create album"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
