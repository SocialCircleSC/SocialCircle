import 'package:community/screens/authscreens/login/login_screen.dart';
import 'package:community/themes/theme.dart';
import 'package:community/screens/authscreens/resetpassword/reset_button.dart';
import 'package:community/screens/authScreens/resetpassword/reset_form.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';

//Maybe Create a backbutton for this page. Because Android has a deault on, but im not sure if i phone does
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
            Text("Please enter your email address",
                style: subTitle.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: displayHeight(context) * 0.01),
            ResetForm(),
            SizedBox(
              height: displayHeight(context) * 0.04,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: ResetButton()),
          ]),
        ),
      ),
    );
  }
}
