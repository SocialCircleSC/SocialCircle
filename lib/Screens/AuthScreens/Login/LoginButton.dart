import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  final String buttonText = "Login";


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: PrimaryColor),
      child: Text(
        buttonText,
        style: textButton.copyWith(color: WhiteColor),
      ),
    );
  }
}
