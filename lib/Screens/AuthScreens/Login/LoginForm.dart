import 'package:community/Screens/NavScreens/NavBar.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = false;
  bool pass = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email Address",
              labelStyle: TextStyle(color: TextFieldColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),
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
        TextButton(
          style: TextButton.styleFrom(
            primary: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: LogInButtonPadding,
          ),
          child: Text("Login"),
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
        ),
      ],
    );
  }

  //firebase
  final auth = FirebaseAuth.instance;

  //Login Function
  void signIn(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => NavBar()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
