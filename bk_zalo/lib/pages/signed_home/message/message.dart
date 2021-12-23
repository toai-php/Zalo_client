import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Image.asset(
            "assets/icons/smile.png",
            width: 15,
            height: 15,
          ),
        ),
        TextSpan(text: '  bold', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' world!'),
      ])),
    );
  }
}
