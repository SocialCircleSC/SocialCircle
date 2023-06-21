import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/profile/editscreens/edit_user_profile.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String email = "";

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
    //String em = "";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      uID = value.get('ID');
      cID = value.get('Church ID');
      fName = value.get('First Name');
      lName = value.get('Last Name');
      pPic = value.get('ProfilePicture');
      //em = value.get('Email Address');
    });

    //Get Status
    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .collection('members')
        .get()
        .then((QuerySnapshot value) {
      for (var element in value.docs) {
        if (element["ID"] == uid) {
          stat = element["Status"];
        }
      }
    });

    setState(() {
      userID = uID;
      churchID = cID;
      firstName = fName;
      lastName = lName;
      profilePic = pPic;
      status = stat;
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
    if (userID.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CircularProgressIndicator(),
        ],
      );
    }
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
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot1) {
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
            return ListView(
              children: [
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: WhiteColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    snapshot1.data!["ProfilePicture"]))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    snapshot1.data!["First Name"] +
                        " " +
                        snapshot1.data!["Last Name"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Center(
                  child: Text(
                    "Status: " + status,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: SecondaryColor,
                    ),
                    child: const Text("Settings"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    firstName: snapshot1.data!['First Name'],
                                    lastName: snapshot1.data!['Last Name'],
                                    userID: snapshot1.data!['ID'],
                                    email: snapshot1.data!['Email Address'],
                                    profilePic:
                                        snapshot1.data!['ProfilePicture'],
                                  )));
                      // if (userID == churchID) {
                      //   // Navigator.push(context,
                      //   // MaterialPageRoute(builder: (context) => EditChurchProfile(firstName: firstName, userID: userID, email: email, profilePic: profilePic))
                      //   // );
                      // } else {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => EditProfile(
                      //                 firstName: snapshot1.data['First Name'],
                      //                 lastName: snapshot1.data['Last Name'],
                      //                 userID: snapshot1.data['ID'],
                      //                 email: snapshot1.data['Email Address'],
                      //                 profilePic:
                      //                     snapshot1.data['ProfilePicture'],
                      //               )));
                      // }
                    },
                  ),
                )),
              ],
            );
          }),
    );
  }

  getLikeCount(document) {
    int likeCount = 0;
    // ignore: prefer_typing_uninitialized_variables
    var exMap;
    exMap = document;
    likeCount = exMap.length;
    return likeCount.toString();
  }

  getLikeStatus(document, id) {
    // ignore: unused_local_variable
    List variable = document;
    if (document.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}
