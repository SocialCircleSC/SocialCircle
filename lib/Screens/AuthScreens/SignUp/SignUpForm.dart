import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm("First Name", false),
        buildInputForm("Last Name", false),
        buildInputForm("Email", false),
        buildInputForm("Phone", false),
        buildInputForm("Password", true),
        buildInputForm("Confirm Password", true),
      ],
    );
  }

  Padding buildInputForm(String hint, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: TextFieldColor),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: PrimaryColor)),
          suffixIcon: pass
              ? IconButton(onPressed: () {}, icon: Icon(Icons.visibility_off))
              : null,
        )),
    );
  }
}
