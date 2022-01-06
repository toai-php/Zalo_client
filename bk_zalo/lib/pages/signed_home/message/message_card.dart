import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/models/chat_model.dart';

class OwnMessage extends StatelessWidget {
  const OwnMessage({
    required Key key,
    required this.chat,
  }) : super(key: key);
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    String time = chat.created.hour.toString().padLeft(2, '0') +
        ':' +
        chat.created.minute.toString().padLeft(2, '0');

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 2 / 3),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xffD5F1FF),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: chat.message,
                  textStyle: const TextStyle(fontSize: 16),
                  hasExpand: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SenderMessage extends StatelessWidget {
  const SenderMessage({
    required Key key,
    required this.chat,
    required this.isLead,
  }) : super(key: key);
  final ChatModel chat;
  final bool isLead;

  @override
  Widget build(BuildContext context) {
    String time = chat.created.hour.toString().padLeft(2, '0') +
        ':' +
        chat.created.minute.toString().padLeft(2, '0');

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 4 / 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 2, right: 3),
              child: isLead
                  ? CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(chat.senderAvt),
                      radius: 20,
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                    ),
            ),
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 12, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: chat.message,
                        textStyle: const TextStyle(fontSize: 16),
                        hasExpand: false,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
