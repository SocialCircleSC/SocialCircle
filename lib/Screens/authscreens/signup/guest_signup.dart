import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../sizes/size.dart';
import '../../../themes/theme.dart';
import '../Login/login_screen.dart';
import 'general_form.dart';

class GuestSignUp extends StatefulWidget {
  const GuestSignUp({super.key});

  @override
  State<GuestSignUp> createState() => _GuestSignUpState();
}

class _GuestSignUpState extends State<GuestSignUp> {
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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
                  "Create Guest Account",
                  style: titleText,
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
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
                      width: displayWidth(context) * 0.02,
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
                height: displayHeight(context) * 0.01,
              ),
              const Padding(
                padding: DefaultPadding,
                child: SignUpForm(guest: true),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
