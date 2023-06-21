import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';



class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  final String buttonText = "Reset Password";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: displayHeight(context) * 0.08,
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
