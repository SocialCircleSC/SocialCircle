import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/profile/editscreens/edit_profile.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:community/sizes/size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../../firestore/delete_post.dart';
import '../../../AuthScreens/Login/login_screen.dart';
import '../../homescreen/bigger_picture.dart';
import '../../homescreen/comments_screen.dart';
import '../../homescreen/edit_post.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? dropdownvalue;
  var items = [
    'Edit',
    'Delete',
  ];
  String currentID = "";
  String userID = "";
  String churchID = "";
  String firstName = "";
  String lastName = "";
  String status = "";
  String profilePic = "";

  Future getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    String currID = uid.toString();
    String uID = "";
    String cID = "";
    String fName = "";
    String lName = "";
    String stat = "";
    String pPic = "";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      uID = value.get('ID');
      cID = value.get('Church ID');
      fName = value.get('First Name');
      lName = value.get('Last Name');
      stat = value.get('Status');
      pPic = value.get('ProfilePicture');
    });

    setState(() {
      userID = uID;
      churchID = cID;
      firstName = fName;
      lastName = lName;
      status = stat;
      profilePic = pPic;
      currentID = currID;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return Stack(
              // clipBehavior: Clip.none,
              // alignment: Alignment.topLeft,
              children: [
                SizedBox(
                    width: displayWidth(context),
                    height: displayHeight(context) * 0.2,
                    child: Image.asset(
                      'lib/assets/background_placeholder.jpg',
                      fit: BoxFit.cover,
                    )),
                Positioned(
                    top: displayHeight(context) * 0.16,
                    left: displayHeight(context) * 0.01,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        snapshot1.data["ProfilePicture"],
                        width: displayWidth(context),
                        fit: BoxFit.cover,
                      ),
                    )),
                Positioned(
                    top: displayHeight(context) * 0.21,
                    left: displayHeight(context) * 0.12,
                    child: Text(
                      snapshot1.data['First Name'] +
                          " " +
                          snapshot1.data['Last Name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Positioned(
                    top: displayHeight(context) * 0.23,
                    left: displayHeight(context) * 0.12,
                    child: Text(
                      snapshot1.data['Status'],
                    )),
                Positioned(
                    top: displayHeight(context) * 0.27,
                    left: displayHeight(context) * 0.01,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Message"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SecondaryColor,
                      ),
                    )),
                if (currentID == snapshot1.data['ID'])
                  Positioned(
                      top: displayHeight(context) * 0.27,
                      left: displayHeight(context) * 0.15,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(firstName: snapshot1.data['First Name'], lastName: snapshot1.data['Last Name'], aboutMe: snapshot1.data['About'], userID: snapshot1.data['ID'], email: snapshot1.data['Email Address'], profilePic: snapshot1.data['ProfilePicture'],)));
                        },
                        child: const Text("Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SecondaryColor,
                        ),
                      )),
                Positioned(
                    top: displayHeight(context) * 0.35,
                    left: displayHeight(context) * 0.01,
                    child: const Text(
                      "About Me",
                      style: TextStyle(fontSize: 20),
                    )),
                if (snapshot1.data['About'] == "")
                  Positioned(
                      top: displayHeight(context) * 0.4,
                      left: displayHeight(context) * 0.01,
                      child: const Text(
                        "Empty right now. Write something about yourself!",
                      )),
                Positioned(
                    top: displayHeight(context) * 0.4,
                    left: displayHeight(context) * 0.01,
                    child: Text(
                      snapshot1.data['About'],
                    )),
              ],
            );
          }),
    );
  }

  getLikeCount(document) {
    int likeCount = 0;
    var exMap;
    exMap = document;
    likeCount = exMap.length;
    return likeCount.toString();
  }

  getLikeStatus(document, id) {
    List variable = document;
    if (document.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}

//logout button
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
}

String removeParenthese(String data) {
  return data.substring(1, data.length - 1);
}

void _goToEditScreen(BuildContext context, String cID, String fName,
    String lName, String status, String textPost, String docID) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPost(
              circleID: cID,
              fName: fName,
              lName: lName,
              status: status,
              docID: docID,
              textField: textPost)));
}
