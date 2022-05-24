// ignore_for_file: prefer_const_constructors

import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  bool checkedValue = false;
  bool newValue = true;

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
            // ignore: prefer_const_constructors
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
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Last Name",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //First Name Controller
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            controller: emailController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "First Name",
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

        Container(
            height: 40,
            width: 1000,
            child: CheckboxListTile(
              title:
                  Text("I agree to the terms and conditions of Social Circle"),
              value: checkedValue,
              onChanged: (bool? value) {
                setState(() {
                  checkedValue = value!;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            )),

        SizedBox(
          height: 20,
        ),

        TextButton(
          style: TextButton.styleFrom(
            primary: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: SignUpButtonPadding,
          ),
          child: Text("Sign Up"),
          onPressed: () {
            //signIn(emailController.text, passwordController.text);
          },
        ),
      ],
    );
  }
}
