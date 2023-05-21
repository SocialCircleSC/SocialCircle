import 'package:flutter/material.dart';

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  
  final ValueSetter<dynamic> onTap;
  const KeyboardKey(
      {super.key,
      required this.label,
      this.value,
      required this.onTap});

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is Widget) {
      return widget.label;
    }
    return Text(
      widget.label,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(
          child: Center(child: renderLabel()),
        ),
      ),
    );
  }
}
