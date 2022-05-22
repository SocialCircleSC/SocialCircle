import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm("Email", false),
        buildInputForm("Password", true),
      ],
    );
  }

  Padding buildInputForm(String label, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: TextFieldColor),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: PrimaryColor),
            ),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      _isObscure = !_isObscure;
                    },
                    icon: _isObscure ? Icon(
                      Icons.visibility_off,
                      color: TextFieldColor):
                      Icon(Icons.visibility, color: PrimaryColor,))
                      
                : null),
      ),
    );
  }
}
