import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:community/sizes/size.dart';

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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                labelStyle: TextStyle(color: TextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              obscureText: !_isObscure,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: TextFieldColor),
                focusedBorder: const UnderlineInputBorder(
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
          SizedBox(height: displayHeight(context) * 0.02),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: WhiteColor,
              backgroundColor: PrimaryColor,
              padding: LogInButtonPadding,
            ),
            child: const Text("Login"),
            onPressed: () {
              signIn(emailController.text, passwordController.text);
            },
          ),
        ],
      ),
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
                    MaterialPageRoute(builder: (context) => const NavBar()))
              })
          // ignore: body_might_complete_normally_catch_error
          .catchError((e) {
        Fluttertoast.showToast(msg: "Please enter a valid email and password");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
