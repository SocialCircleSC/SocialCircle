// ignore_for_file: unnecessary_new, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socialorb/Screens/authscreens/signup/church_signup.dart';
import 'package:socialorb/Screens/authscreens/signup/general_signup.dart';
import 'package:socialorb/screens/authscreens/login/login_form.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:socialorb/screens/authScreens/resetpassword/reset_password_screen.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  //CommunitCode
  TextEditingController churchCode = new TextEditingController();

  // Show user type selection dialog
  void _showSignUpOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("I am a", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: PrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Member',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpChurch(planID: 0)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: PrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Church',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // You can uncomment this if you want to add the Guest option back
                /*
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GuestSignUp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: PrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Guest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

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
                onTap: _showSignUpOptions, // Show the dialog when tapped
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
        ]),
      ),
    );
  }
}

void openURl(String site) async {
  if(await launchUrl(Uri.parse(site))){
    await launchUrl(Uri.parse(site));
  }else{
    throw 'Could not launch site';
  }
}