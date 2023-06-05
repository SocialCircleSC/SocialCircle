// ignore_for_file: unused_local_variable

import 'package:community/Screens/navscreens/navbar/nav_bar.dart';
import 'package:community/firestore/churchSignUpData.dart';
import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:community/sizes/size.dart';

//Fill out entire screen with content
//Make the bottom navigation bar thin
//Make it look like the YouVersion Bible App
//Make it
//Remove
//Add event to calendar

class SignUpFormChurch extends StatefulWidget {
  const SignUpFormChurch({Key? key}) : super(key: key);

  @override
  State<SignUpFormChurch> createState() => _SignUpFormChurchState();
}

enum SingingCharacter { starter, standard, premium, payg }

class _SignUpFormChurchState extends State<SignUpFormChurch> {
  SingingCharacter? _character = SingingCharacter.starter;

  String plan = "Starter";
  List<String> paymentPlans = ["Starter", "Standard", "Premium", "PAYG"];

  bool _isObscure = false;
  bool checkedValue = false;
  bool newValue = true;
  String empty = "empty";

  final auth = FirebaseAuth.instance;
  TextEditingController churchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController weeklyEventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Church Name Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: churchNameController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Church Name",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        // Address Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: addressController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Address(Include City and Zip Code)",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Email Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: emailController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Phone Number Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: phoneNumberController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Event1 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: weeklyEventController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Add one weekly event",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Text about adding more events
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child:
                Text("Don't worry you will be able to add more events later")),

        //Password Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            obscureText: !_isObscure,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        //Confirm Password Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            obscureText: !_isObscure,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        SizedBox(
          height: displayHeight(context) * 0.01,
        ),

        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: SignUpButtonPadding,
          ),
          child: const Text("Sign Up"),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      const Text(
                        "Choose Your Plan",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Details: All plans share the same features. The difference in price is based on the size of your church ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Features: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "1) Tithes and Offering portal ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "2) Unlimited Messaging between all Church members",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "3) Online enagement dashboard for all members to share stories, annoucements prayers and more!",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "To select a plan, press the circle next to plan, then the plan itself in order to confirm",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: PrimaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 5),
                            ListTile(
                              title: const Text("Starter Plan: \$39.99"),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.starter,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              subtitle: const Text("Max Members: 200"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text("Standard Plan: \$59.99"),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.standard,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              subtitle: const Text("Max Members: 500"),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text("Premium Plan: \$129.99"),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.premium,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              subtitle: const Text("Max Members: 1000"),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title:
                                  const Text("Pay As You Grow Plan: \$199.99"),
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.payg,
                                groupValue: _character,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              subtitle: const Text(
                                  "Base Members: 1500 (+\$25 per 250 additional members)"),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Pay"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: SecondaryColor),
                      ),
                      
                    ],
                  );
                }));
            //signUp(emailController.text, passwordController.text);
          },
        ),
      ],
    );
  }

  void signUp(String email, String password) async {
    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
          msg:
              "Please make sure your password is the same as your confirm passowrd");
    }
    // ignore: unrelated_type_equality_checks

    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        churchSetup(
          churchNameController.text,
          addressController.text,
          phoneNumberController.text,
          emailController.text,
          weeklyEventController.text,
        );

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NavBar()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: "The Password is too weak");
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(msg: "Email already exists");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
