import 'package:bk_zalo/components/profile_avatar.dart';
import 'package:bk_zalo/pages/signed_home/timeline/add_post.dart';
import 'package:flutter/material.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: ProfileAvatar(
                    imageUrl:
                        "https://guantanamocity.org/wp-content/uploads/2020/12/tong-hop-avatar-anime-avatar-anime-doi-cool-ngau-cute-panda-brown-1.jpg"),
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
                          width: 1.0, color: Theme.of(context).dividerColor),
                      right: BorderSide(
                          width: 1.0, color: Theme.of(context).dividerColor),
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
                          width: 1.0, color: Theme.of(context).dividerColor),
                      right: BorderSide(
                          width: 1.0, color: Theme.of(context).dividerColor),
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
                          width: 1.0, color: Theme.of(context).dividerColor),
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
