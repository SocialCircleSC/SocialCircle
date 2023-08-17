import 'package:socialorb/screens/authscreens/login/login_screen.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:socialorb/screens/authscreens/resetpassword/reset_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
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
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: PrimaryColor,
            ),
          ),
        ),
        body: Padding(
          padding: DefaultPadding,
          child: Column(children: [
            SizedBox(
              height: displayHeight(context) * 0.1,
            ),
            Text("Reset Password", style: titleText),
            SizedBox(
              height: displayHeight(context) * 0.01,
            ),
            TextField(
              controller: emailController,
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: TextFieldColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: PrimaryColor))),
            ),
            SizedBox(height: displayHeight(context) * 0.01),
            //const ResetForm(),
            SizedBox(
              height: displayHeight(context) * 0.04,
            ),
            GestureDetector(
                onTap: () async {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                  Fluttertoast.showToast(
                      msg: "Please check your email to reset password");
                },
                child: const ResetButton()),
          ]),
        ),
      ),
    );
  }
}
