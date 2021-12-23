import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({
    Key? key,
    required this.controller,
    this.focusNode,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List<Widget> _listEmoji = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          onChanged: _onChange,
          controller: widget.controller,
          cursorColor: const Color(0xFF848D94),
          focusNode: widget.focusNode,
          style: TextStyle(
            fontSize: 17,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
      ],
    );
  }

  void _onChange(String s) {
    final val = TextSelection.collapsed(offset: widget.controller.text.length);
    widget.controller.selection = val;
  }

  Widget _showEmoji() {
    if (_listEmoji.isEmpty) return Container();
    return Container();
  }
}
