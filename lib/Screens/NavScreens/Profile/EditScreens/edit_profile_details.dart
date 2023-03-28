// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/screens/navscreens/profile/editscreens/editchurchfolder/FirestoreUpdate.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:community/sizes/size.dart';

class EditProfileDetails extends StatefulWidget {
  const EditProfileDetails({Key? key}) : super(key: key);

  @override
  State<EditProfileDetails> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  List<Map<String, dynamic>> updatedUserdata = [];

  Future getCurrentUserInfo() async {
    List<Map<String, dynamic>> userData = [];

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    // ignore: unused_local_variable
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      userData.add({"First Name": value.get('First Name')});
      userData.add({"Last Name": value.get('Last Name')});
      userData.add({"Email Address": value.get('Email Address')});
      userData.add({"About Me": value.get('About Me')});
    });

    setState(() {
      updatedUserdata = userData;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
            );
          }),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: PrimaryColor,
          ),
        ),
        title: const Text(
          "Edit Profile Details",
          style: TextStyle(color: BlackColor),
        ),
      ),

      body: Padding(
        padding: CenterPadding,
        child: Column(
          children: [
            //First Name
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText:
                    removeParenthese(updatedUserdata[0].values.toString()),
                labelStyle: TextStyle(color: TextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
            ),

            //Last Name
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText:
                    removeParenthese(updatedUserdata[1].values.toString()),
                labelStyle: TextStyle(color: TextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
            ),

            //Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText:
                    removeParenthese(updatedUserdata[2].values.toString()),
                labelStyle: TextStyle(color: TextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
            ),

            //About Me
            TextField(
              controller: aboutMeController,
              decoration: InputDecoration(
                labelText: "About Me",
                labelStyle: TextStyle(color: TextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
            ),

            SizedBox(
              height: displayHeight(context) * 0.01,
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: WhiteColor, backgroundColor: PrimaryColor,
                //padding: SignUpButtonPadding,
              ),
              child: Text("Update"),
              onPressed: () {
                updateData();
                //signUp(emailController.text, passwordController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateData() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        aboutMeController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please to fill out every field");
    } else {
      updateProfile(firstNameController.text, lastNameController.text,
          emailController.text, aboutMeController.text);

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => NavBar()));
    }
  }
}

String removeParenthese(String data) {
  return data.substring(1, data.length - 1);
}
