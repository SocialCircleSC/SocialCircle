// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:community/Screens/AuthScreens/Login/AltLogIn.dart';
import 'package:community/Screens/AuthScreens/Login/LoginButton.dart';
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
          LoginButton(),
          SizedBox(
            height: 25,
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

  //Login Function
  void signIn(String email, String password) async {
    if (formKey.currentState!.validate()) {
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
    }
  }
}












  // //email field
  //   final emailField = TextFormField(
  //     autofocus: false,
  //     controller: emailController,
  //     keyboardType: TextInputType.emailAddress,
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return ("Please Enter your email");
  //       }
  //       //reg expression for email validation
  //       if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
  //         return ("Please Enter a valid email");
  //       }
  //       return null;
  //     },
  //     onSaved: (value) {
  //       emailController.text = value!;
  //     },
  //     textInputAction: TextInputAction.next,
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(Icons.mail),
  //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
  //       hintText: "Email",
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular((10))),
  //     ),
  //   );

  //   //password field
  //   final passwordField = TextFormField(
  //     autofocus: false,
  //     controller: passwordController,
  //     obscureText: true,
  //     validator: (value) {
  //       RegExp regex = new RegExp(r'^.{6,}$');
  //       if (value!.isEmpty) {
  //         return ("Password is required for Login");
  //       }

  //       if (!regex.hasMatch(value)) {
  //         return ("Enter Valid Password(Min. 6 Characters)");
  //       }
  //     },
  //     onSaved: (value) {
  //       passwordController.text = value!;
  //     },
  //     textInputAction: TextInputAction.done,
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(Icons.vpn_key),
  //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
  //       hintText: "Password",
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular((10))),
  //     ),
  //   );

  //   final loginButton = Material(
  //     elevation: 5,
  //     borderRadius: BorderRadius.circular(30),
  //     color: Colors.blueAccent,
  //     child: MaterialButton(
  //         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
  //         minWidth: MediaQuery.of(context).size.width,
  //         onPressed: () {
  //           signIn(emailController.text, passwordController.text);
  //         },
  //         child: Text(
  //           "Login",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
  //         )),
  //   );


















// return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(36.0),
//               child: Form(
//                   key: formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 200,
//                         child:
//                             Image.asset("assets/logo.png", fit: BoxFit.contain),
//                       ),
//                       SizedBox(height: 45),
//                       emailField,
//                       SizedBox(height: 25),
//                       passwordField,
//                       SizedBox(height: 35),
//                       loginButton,
//                       SizedBox(height: 15),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text("Dont have an account? "),
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             RegistrationScreen()));
//                               },
//                               child: Text("SignUp",
//                                   style: TextStyle(
//                                       color: Colors.blueAccent,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 15)))
//                         ],
//                       )
//                     ],
//                   )),
//             ),
//           ),
//         ),
//       ),
//     );