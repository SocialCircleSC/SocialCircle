// ignore_for_file: unnecessary_new, prefer_const_constructors, library_private_types_in_public_api

import 'package:socialorb/screens/authscreens/login/login_form.dart';
import 'package:socialorb/screens/gettingstarted/choose_user_type.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:socialorb/screens/authScreens/resetpassword/reset_password_screen.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: displayHeight(context) * 0.08,
          ),

          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: displayHeight(context) * 0.15,
              child: Image(image: AssetImage("lib/assets/logo.png")),
            ),
          ),

          // SizedBox(
          //   height: displayHeight(context) * 0.01,
          // ),

          // Align(
          //   alignment: Alignment.center,
          //   child: SizedBox(
          //     height: displayHeight(context) * 0.03,
          //     child: Text(
          //       "SocialOrb",
          //       style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          //     ),
          //   ),
          // ),

          SizedBox(
            height: displayHeight(context) * 0.07,
          ),

          Text(
            "Welcome!",
            style: titleText,
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          Row(
            children: [
              Text(
                "Don't have an Account?",
                style: subTitle,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseUser(),
                    ),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: textButton.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: displayHeight(context) * 0.009,
          ),
          LoginForm(),
          SizedBox(
            height: displayHeight(context) * 0.05,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen()));
            },
            child: Text(
              "Forgot password?",
              style: TextStyle(
                  color: ZambeziColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),

          // Text(
          //   "Or log in with:",
          //   style: subTitle.copyWith(color: BlackColor),
          // ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          // AltLogin(),
        ]),
      ),
    );
  }
}
