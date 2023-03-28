import 'package:community/Screens/AuthScreens/Login/login_screen.dart';
import 'package:community/Screens/AuthScreens/signup/general_signup.dart';
import 'package:community/Screens/AuthScreens/signup/church_signup.dart';
import 'package:community/themes/theme.dart';
import 'package:community/sizes/size.dart';
import 'package:flutter/material.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
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
          backgroundColor: PrimaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Choose User Type',
            style: TextStyle(color: WhiteColor),
          ),
          leading: IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: WhiteColor,
            ),
          ),
        ),
        body: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                height: displayHeight(context) * 0.1,
              ),
              const Padding(
                padding: CenterPadding2,
                child: Text(
                  'I am a',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: const Text(
                  'Member',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor, backgroundColor: PrimaryColor,
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpChurch()));
                },
                child: const Text(
                  'Church',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor, backgroundColor: PrimaryColor,
                ),
              ),
            ]),
      ),
    );
  }
}
