import 'package:bk_zalo/components/emoji_picker.dart';
import 'package:flutter/material.dart';

class TextFieldColorizer extends TextEditingController {
  String cpy = "";

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<InlineSpan> _list = [];

    var listStr = text.split(' ');
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

    return TextSpan(style: style, children: _list);
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
