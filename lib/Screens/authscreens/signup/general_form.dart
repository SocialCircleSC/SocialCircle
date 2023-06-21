// ignore_for_file: prefer_const_constructors, dead_code

import 'package:community/screens/gettingstarted/choose_church.dart';
import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:community/storage/storage_services.dart';
import 'package:community/sizes/size.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final Storage storage = Storage();
  bool _isObscure = true;
  bool checkedValue = false;
  bool newValue = true;

  final auth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //First Name Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: "First Name",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Last Name Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Email Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Password Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            obscureText: !_isObscure,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        //Confirm Password Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            obscureText: !_isObscure,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        SizedBox(
          height: displayHeight(context) * 0.02,
        ),

        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: SignUpButtonPadding,
          ),
          child: Text("Sign Up"),
          onPressed: () {
            if (passwordController.text != confirmPasswordController.text) {
              Fluttertoast.showToast(
                  msg:
                      "Please make sure your password is the same as your confirm passowrd");
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseChurch(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text)));
            }
          },
        ),
      ],
    );
  }

  void signUp(String email, String password) {
    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
          msg:
              "Please make sure your password is the same as your confirm passowrd");
    }
  }
}
