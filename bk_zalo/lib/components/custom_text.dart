import 'package:bk_zalo/components/emoji_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.hasExpand = true,
    this.maxLine,
    this.expandStyle = const TextStyle(color: Colors.blue),
  }) : super(key: key);
  final String text;
  final TextStyle textStyle;
  final TextStyle expandStyle;
  final bool hasExpand;
  final int? maxLine;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  String textToDisplay = "";

  bool get needShowMore => (widget.text.length > 40 &&
      textToDisplay.length <= 40 &&
      widget.hasExpand);
  bool get needShowLess => (widget.text.length > 40 &&
      textToDisplay.length > 40 &&
      widget.hasExpand);

  @override
  void initState() {
    // TODO: implement initState
    textToDisplay = (widget.text.length > 40 && widget.hasExpand)
        ? widget.text.substring(0, 40)
        : widget.text;
    super.initState();
  }

  TextSpan buildTextSpan({
    TextStyle? style,
  }) {
    List<InlineSpan> _list = [];

    var listStr = textToDisplay.split(' ');
    for (var s in listStr) {
      if (_listEmoji.contains(s)) {
        String path = getEmojiList()
            .keys
            .firstWhere((k) => getEmojiList()[k] == s, orElse: () => '');
        _list.add(WidgetSpan(
          baseline: TextBaseline.ideographic,
          alignment: PlaceholderAlignment.aboveBaseline,
          child: Image.asset(
            "assets/icons/" + path + ".png",
            width: style?.fontSize ?? 20,
            height: style?.fontSize ?? 20,
          ),
        ));
        for (int i = 0; i < s.length - 1; i++) {
          _list.add(const WidgetSpan(child: SizedBox.shrink()));
        }
      } else {
        _list.add(TextSpan(text: s, style: style));
      }
      _list.add(TextSpan(text: ' ', style: style));
    }
    TextStyle _st = widget.expandStyle.merge(widget.textStyle);

    if (needShowMore) {
      _list.add(
        TextSpan(
            text: "show more",
            style: _st,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  textToDisplay = widget.text;
                });
              }),
      );
    }
    //else if the text is already expanded we contract it back
    else if (needShowLess) {
      _list.add(
        TextSpan(
            text: "show less",
            style: _st,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  textToDisplay = widget.text.substring(0, 40);
                });
              }),
      );
    }

    return TextSpan(style: style, children: _list);
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      buildTextSpan(style: widget.textStyle),
      maxLines: widget.maxLine,
      overflow: widget.maxLine != null ? TextOverflow.ellipsis : null,
    );
  }
}

final _listEmoji = [
  ':)',
  ':~',
  ':b',
  ':\')',
  '8-)',
  ':-((',
  ':\$',
  ':3',
  ':z',
  ':((',
  '&-(',
  ':-h',
  ':p',
  ':d',
  ':o',
  ':(',
  ';-)',
  '--b',
  ':))',
  ':-*',
  ';p',
  ';-d',
  '/-showlove',
  ';d',
  ';o',
  ';g',
  '|-)',
  ':!',
  ':l',
  ':>',
  ':;',
  ';f',
  ':v',
  ':wipe',
  ':-dig',
  ':handclap',
  'b-)',
  ':-r',
  ':-<',
  ':-o',
  ';-s',
  ';?',
  ';-x',
  ':-f',
  '8*)',
  ';!',
  ';-!',
  ';xx',
  ':-bye',
  '>-|',
  'p-(',
  ':--|',
  ':q',
  'x-)',
  ':*',
  ';-a',
  '8*',
  ':|',
  ':x',
  ':t',
  ';-/',
  ':-l',
  '\$-)',
  '/-beer',
  '/-coffee',
  '/-rose',
  '/-fade',
  '/-bd',
  '/-bome',
  '/-cake',
  '/-heart',
  '/-break',
  '/-shit',
  '/-li',
  '/-flag',
  '/-strong',
  '/-weak',
  '/-ok',
  '/-v',
  '/-thanks',
  '/-punch',
  '/-share',
  '_()_',
  '/-no',
  '/-bad',
  '/-loveu',
  '/-redboring',
  '/-thief',
  '/-come',
];
