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
    String tt = text.splitMapJoin(RegExp(r' :>'), onMatch: (m) {
      _list.add(TextSpan(style: style, text: ' ', children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.bottom,
          child: Image.asset(
            "assets/icons/smile.png",
            width: style?.fontSize ?? 17,
            height: style?.fontSize ?? 17,
          ),
        ),
        const WidgetSpan(
            child: SizedBox(
          width: 0,
          height: 0,
        )),
      ]));
      return '';
    }, onNonMatch: (t) {
      _list.add(TextSpan(text: t, style: style));
      return '';
    });

    return TextSpan(style: style, children: _list);
  }
}
