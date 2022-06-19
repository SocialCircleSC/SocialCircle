// ignore_for_file: prefer_const_constructors


import 'package:community/Screens/AuthScreens/Login/LoginScreen.dart';
import 'package:community/Screens/AuthScreens/SignUp/SignUpForm.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(

         appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //title: const Text('Post to Church', style: TextStyle(color: PrimaryColor),),
        leading: IconButton(
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  LoginScreen()),
            );
          }),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: PrimaryColor,
          ),
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: DefaultPadding,
                child: Text(
                  "Create Account",
                  style: titleText,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: DefaultPadding,
                child: Row(
                  children: [
                    Text(
                      "Already a member?",
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
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Log In",
                        style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: DefaultPadding,
                child: SignUpForm(),
              ),
    
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: DefaultPadding,
              //   child: Text("Or Sign Up with"),
              // ),
              SizedBox(
                height: 5,
              ),
    
              // Center(
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         TextButton.icon(
              //           onPressed: signInWithGoogle,
              //           icon: Icon(Icons.facebook),
              //           label: Text("Google"),
              //           style: TextButton.styleFrom(onSurface: PrimaryColor),
              //         ),
              //       ]),
              // ),
    
              //AltLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
