import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';

class checkBox extends StatefulWidget {
  final String text;
  const checkBox(this.text);

  @override
  State<checkBox> createState() => _checkBoxState();
}

class _checkBoxState extends State<checkBox> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: DarkGreyColor),
                ),
                child: _isSelected ? Icon(
                  Icons.check,
                  size: 17,
                  color: Colors.green,)
                  :null,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(widget.text),
          ],
        ),
      ],
    );
  }
}
