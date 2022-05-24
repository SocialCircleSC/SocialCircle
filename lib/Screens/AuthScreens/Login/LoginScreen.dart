// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:community/Screens/AuthScreens/Login/AltLogIn.dart';
import 'package:community/Screens/AuthScreens/Login/LoginForm.dart';
import 'package:community/Screens/AuthScreens/SignUp/RegisScreen.dart';
import 'package:community/Screens/AuthScreens/SignUp/SignUp.dart';
import 'package:community/themes/theme.dart';
import 'package:community/Screens/HomeScreen/HomeScreen.dart';
import 'package:community/Screens/NavScreens/NavBar.dart';
import 'package:community/Screens/ResetPassword/ResetPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            height: 120,
          ),
          Text(
            "Welcome!",
            style: titleText,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Don't have an Account?",
                style: subTitle,
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
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
            height: 10,
          ),
          LoginForm(),
          SizedBox(
            height: 20,
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
            height: 20,
          ),

          Text(
            "Or log in with:",
            style: subTitle.copyWith(color: BlackColor),
          ),
          SizedBox(
            height: 20,
          ),
          AltLogin(),
        ]),
      ),
    );
  }


}
