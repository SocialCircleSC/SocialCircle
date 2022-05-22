// ignore_for_file: prefer_const_constructors

import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";

class AltLogin extends StatelessWidget {
  const AltLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildButton(
          iconImage: Image(
            height: 20,
            width: 20,
            image: AssetImage('lib/assets/facebook_icon.png'),
          ),
          textButton: 'Facebook',
        ),
        BuildButton(
          iconImage: Image(
            height: 20,
            width: 20,
            image: AssetImage('lib/assets/google_icon.png'),
          ),
          textButton: 'Google',
        ),
      ],
    );
  }
}

class BuildButton extends StatelessWidget {
  final Image iconImage;
  final String textButton;
  BuildButton({required this.iconImage, required this.textButton});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.06,
      width: mediaQuery.width * 0.32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(children: [
        iconImage,
        SizedBox(width: 5),
        Text(textButton),
      ]),
    );
  }
}
