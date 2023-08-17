import 'package:socialorb/Screens/AuthScreens/Login/login_screen.dart';
import 'package:socialorb/Screens/AuthScreens/signup/general_signup.dart';
import 'package:socialorb/Screens/AuthScreens/signup/church_signup.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  TextEditingController myController = TextEditingController();
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: PrimaryColor,
                ),
                child: const Text(
                  'Member',
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
                onPressed: () async {
                  showAlertDialog(BuildContext context) {
                    // set up the buttons
                    Widget cancelButton = TextButton(
                      child: const Text("I do not have my code"),
                      onPressed: () async {
                        //Open Email
                        Uri url =
                            Uri.parse('https://calendly.com/socialorb/30min');
                        if (await launchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    );
                    Widget continueButton = TextButton(
                      child: const Text("Continue"),
                      onPressed: () {
                        if (myController.text ==
                            dotenv.env['CHURCH_SIGNUP_CODE']!) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpChurch()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "The code is correct",
                              toastLength: Toast.LENGTH_LONG);
                        }
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: const Text("Church Confirmation"),
                      content: TextField(
                        controller: myController,
                        decoration:
                            const InputDecoration(hintText: "Type your code"),
                      ),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }

                  showAlertDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: PrimaryColor,
                ),
                child: const Text(
                  'Church',
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
