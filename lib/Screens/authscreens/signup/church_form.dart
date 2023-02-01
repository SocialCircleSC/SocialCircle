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

class _SignUpFormChurchState extends State<SignUpFormChurch> {
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

        SizedBox(
          height: displayHeight(context) * 0.01,
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
        print(e);
      }
    }
  }
}
