import 'package:community/Screens/AuthScreens/Login/LoginScreen.dart';
import 'package:community/themes/theme.dart';
import 'package:community/Screens/ResetPassword/ResetButton.dart';
import 'package:community/Screens/ResetPassword/ResetForm.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


//Maybe Create a backbutton for this page. Because Android has a deault on, but im not sure if i phone does
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: DefaultPadding,
        child: Column(children: [
          SizedBox(
            height: 200,
          ),
          Text("Reset Password", style: titleText),
          SizedBox(
            height: 5,
          ),
          Text("Please enter your email address",
              style: subTitle.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 10),
          ResetForm(),
          SizedBox(height: 40,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()));
            },
            child: ResetButton()),
        ]),
      ),
    );
  }
}
