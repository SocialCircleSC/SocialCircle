import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/Screens/authscreens/login/login_screen.dart';
import 'package:socialorb/Screens/authscreens/signup/church_form.dart';
import 'package:socialorb/Screens/authscreens/signup/general_signup.dart';
import 'package:socialorb/Screens/authscreens/signup/subscription.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:socialorb/themes/theme.dart';

class ConfirmSignUp extends StatefulWidget {
  final String churchStripeID;
  final String churchName;
  final String churchAddress;
  final String email;
  final String phoneNumber;
  final String weeklyEvent;

  const ConfirmSignUp({super.key,
    required this.churchStripeID,
    required this.churchName,
    required this.churchAddress,
    required this.email,
    required this.phoneNumber,
    required this.weeklyEvent,
  
  });

  @override
  State<ConfirmSignUp> createState() => _ConfirmSignUpState();
}

class _ConfirmSignUpState extends State<ConfirmSignUp> {

  TextEditingController myController = TextEditingController();
  TextEditingController churchCode = TextEditingController();
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
                    fontSize: 30,
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
                          builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: PrimaryColor,
                ),
                child: const Text(
                  'Not Finished',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
              context,
                MaterialPageRoute(
                  builder: (context) => SubScreen(
                    churchName: widget.churchName,
                    churchAddress: widget.churchAddress,
                    email: widget.email,
                    phoneNumber: widget.phoneNumber,
                    weeklyEvent: widget.weeklyEvent, churchStripeID: widget.churchStripeID,
                  ),
                ),
            );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: PrimaryColor,
                ),
                child: const Text(
                  'Finished',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const GuestSignUp()));
              //   },
              //   child: const Text(
              //     'Guest',
              //     style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: WhiteColor,
              //     backgroundColor: PrimaryColor,
              //   ),
              // ),
            ]),
      ),
    );
  }
}