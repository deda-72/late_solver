import 'package:flutter/material.dart';

class HiddenTextField extends StatefulWidget {
  final VoidCallback onKeyboardPresented;

  const HiddenTextField({Key? key, required this.onKeyboardPresented})
      : super(key: key);

  @override
  _HiddenTextFieldState createState() => _HiddenTextFieldState();
}

class _HiddenTextFieldState extends State<HiddenTextField> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    // Request focus on the hidden TextField when the widget is built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onKeyboardPresented();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      style: TextStyle(color: Colors.transparent),
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      showCursor: false,
      autofocus: true,
    );
  }
}
