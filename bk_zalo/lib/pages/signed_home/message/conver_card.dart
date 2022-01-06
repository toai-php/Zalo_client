import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bk_zalo/components/custom_page_route.dart';
import 'package:bk_zalo/components/custom_text.dart';
import 'package:bk_zalo/models/conversation.dart';
import 'package:bk_zalo/pages/signed_home/message/chat.dart';

class ConverCard extends StatefulWidget {
  const ConverCard({
    required Key key,
    required this.conver,
    required this.onQuit,
  }) : super(key: key);

  final ConversationModel conver;
  final void Function() onQuit;

  @override
  _ConverCardState createState() => _ConverCardState();
}

class _ConverCardState extends State<ConverCard> {
  String timeAgo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    final different = now.difference(widget.conver.created);
    if (different.inSeconds <= 60) {
      timeAgo = 'just now ';
    } else if (different.inHours <= 24) {
      timeAgo = different.inHours.toString() + ' hour ago';
    } else if (different.inDays <= 7) {
      timeAgo = widget.conver.created.weekday.toString() +
          ' at ' +
          widget.conver.created.hour.toString() +
          ':' +
          widget.conver.created.minute.toString();
    } else if (different.inDays <= 365) {
      timeAgo = widget.conver.created.day.toString() +
          '/' +
          widget.conver.created.month.toString();
    } else {
      timeAgo =
          (now.year - widget.conver.created.year).toString() + ' year ago';
    }
  }

  _colorChoose() {
    if (widget.conver.numUnread <= 0) return Colors.transparent;
    return const Color(0xffFE5051);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        Navigator.of(context).push(CustomPageRoute(ChatScreen(
          partnerName: widget.conver.partnerName,
          partnerId: widget.conver.partnerId,
          converId: widget.conver.id,
          onQuit: () {
            widget.onQuit();
          },
        )));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          backgroundImage: CachedNetworkImageProvider(widget.conver.partnerAvt),
        ),
        title: Text(
          widget.conver.partnerName,
          style: TextStyle(
              fontSize: 18,
              fontWeight: widget.conver.numUnread > 0 ? FontWeight.bold : null),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              timeAgo,
              style: TextStyle(
                  fontWeight:
                      widget.conver.numUnread > 0 ? FontWeight.bold : null),
            ),
            Container(
              width: 23,
              height: 20,
              child: widget.conver.numUnread > 0
                  ? Center(
                      child: Text(
                        widget.conver.numUnread.toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    )
                  : null,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _colorChoose()),
            )
          ],
        ),
        subtitle: CustomText(
          text: widget.conver.lastMessage,
          textStyle: TextStyle(
              color: widget.conver.numUnread > 0 ? Colors.black : null,
              fontSize: 16,
              fontWeight: widget.conver.numUnread > 0
                  ? FontWeight.bold
                  : FontWeight.w400),
          maxLine: 1,
          hasExpand: false,
        ),
      ),
    );
  }
}
