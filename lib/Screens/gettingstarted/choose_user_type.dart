import 'package:socialorb/Screens/AuthScreens/Login/login_screen.dart';
import 'package:socialorb/Screens/AuthScreens/signup/general_signup.dart';
import 'package:socialorb/Screens/AuthScreens/signup/church_signup.dart';
import 'package:socialorb/Screens/authscreens/signup/church_sub.dart';
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
                    showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Do you have your code?"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Main text
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    controller: churchCode,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter sign up code',
                                      hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),

                                  // Spacing between the list and the buttons
                                  SizedBox(height: 20),

                                  // Row with two buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        
                                        onPressed: () {
                                         
                                          if(churchCode.text == dotenv.env['CHURCH_SIGNUP_CODE']!){
                                            
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SignUpChurch(planID: 0)),);
                                            
                                            
                                          }else{

                                          }

                                        },
                                        child: Text('Yes'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          openURl(dotenv.env['CALENDY_SITE']!);
                                        },
                                        child: Text('No'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
    },
  );
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

void openURl(String site) async {
  if(await launchUrl(Uri.parse(site))){
    await launchUrl(Uri.parse(site));
  }else{
    throw 'Could not launch site';
  }
}