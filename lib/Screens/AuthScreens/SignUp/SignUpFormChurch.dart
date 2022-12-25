import 'package:community/Screens/GettingStarted.dart/ChooseChurch.dart';
import 'package:community/Screens/NavScreens/NavBar/NavBar.dart';
import 'package:community/firestore/churchSignUpData.dart';
import 'package:community/firestore/memberSignUpData.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


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

class _SignUpFormChurchState extends State<SignUpFormChurch> {
  bool _isObscure = true;
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
  TextEditingController bibleVerseController = TextEditingController();
  TextEditingController weeklyService1Controller = TextEditingController();
  TextEditingController weeklyService2Controller = TextEditingController();
  TextEditingController weeklyService3Controller = TextEditingController();
  TextEditingController weeklyService4Controller = TextEditingController();
  TextEditingController weeklyService5Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Church Name Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
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

        //Bible Verse Motto Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(150)
            ],
            controller: bibleVerseController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Bible Verse Motto",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Weekly Service 1 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            controller: weeklyService1Controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Weekly Service 1",
              hintText: "ex. Sunday Service 10AM  - 12 PM",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Weekly Service 2 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            controller: weeklyService2Controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Weekly Service 2",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Weekly Service 3 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            controller: weeklyService3Controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Weekly Service 3",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Weekly Service 4 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            controller: weeklyService4Controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Weekly Service 4",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Weekly Service 5 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            controller: weeklyService5Controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Weekly Service 5",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Password Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(45)
            ],
            obscureText: !_isObscure,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: PrimaryColor),
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

        const SizedBox(
          height: 20,
        ),

        TextButton(
          style: TextButton.styleFrom(
            primary: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: SignUpButtonPadding,
          ),
          child: const Text("Sign Up"),
          onPressed: () {
            signUp(emailController.text, passwordController.text);
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
    else if (addressController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Address field cannot be empty");
    } else if (phoneNumberController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number field cannot be empty");
    } else if (bibleVerseController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Bible Verse field cannot be empty");
    } else if (weeklyService1Controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "You need atleast one weekly service");
    } 
    
    // else if (weeklyService2Controller.text.isEmpty) {
    //   weeklyService2Controller.text = empty;
    // } else if (weeklyService3Controller.text.isEmpty) {
    //   weeklyService3Controller.text = empty;
    // } else if (weeklyService4Controller.text.isEmpty) {
    //   weeklyService4Controller.text = empty;
    // } else if (weeklyService5Controller.text.isEmpty) {
    //   weeklyService5Controller.text = empty;
    // }
     else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        churchSetup(
            churchNameController.text,
            addressController.text,
            phoneNumberController.text,
            bibleVerseController.text,
            emailController.text,
            weeklyService1Controller.text,
            weeklyService2Controller.text,
            weeklyService3Controller.text,
            weeklyService4Controller.text,
            weeklyService5Controller.text);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NavBar()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: "The Password is too weak");
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(msg: "Email already exists");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
