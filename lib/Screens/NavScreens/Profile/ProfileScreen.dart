import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/Screens/AuthScreens/Login/LoginScreen.dart';
import 'package:community/Screens/GettingStarted.dart/ChooseChurch.dart';
import 'package:community/Screens/NavScreens/Profile/EditScreens/EditChurchFolder/EditChurch.dart';
import 'package:community/Screens/NavScreens/Profile/EditScreens/EditProfileDetails.dart';
import 'package:community/Screens/NavScreens/Profile/EditScreens/EditProfilePicture.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  String imagePath = 'lib/assets/holderimage.jpg';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) return;

      final imageTemporary = File(image!.path);

      setState(() {
        this.image = imageTemporary;
        imagePath = (image.path).toString();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  List<Map<String, dynamic>> userInfo = [];

  Future getUserInfo() async {
    List<Map<String, dynamic>> userData = [];

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      userData.add({"First Name": value.get('First Name')});
      userData.add({"Last Name": value.get('Last Name')});
      userData.add({"Church Name": value.get('Church Name')});
      userData.add({"About Me": value.get('About Me')});
      userData.add({"Status": value.get('Status')});
    });

    setState(() {
      userInfo = userData;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: Future.wait([
              getUserInfo(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // ignore: prefer_const_constructors
                    //  image != null
                    //     ? Image.file(image!)
                    //     : Text("No Image selected"),
                    const Padding(
                      padding: CenterPadding2,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('lib/assets/holderimage.jpg'),
                        radius: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      removeParenthese(userInfo[0].values.toString()) +
                          " " +
                          removeParenthese(userInfo[1].values.toString()),
                      style: const TextStyle(
                        color: BlackColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      removeParenthese(userInfo[2].values.toString()),
                      style: const TextStyle(
                        color: BlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: LeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Status: " +
                              "" +
                              removeParenthese(userInfo[4].values.toString()),
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: BlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: LeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "About Me: " +
                              removeParenthese(userInfo[3].values.toString()),
                          style: const TextStyle(
                            color: BlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: LeftPadding,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: OutlineButton(
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 12),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Choose Option',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: PrimaryColor),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const EditProfileDetails()),
                                                );
                                              },
                                              child: const Text(
                                                'Change Profile Details',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: PrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const EditProfilePicture()),
                                                );
                                              },
                                              child: const Text(
                                                'Change Profile Picture',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: PrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const ChooseChurch()),
                                                );
                                              },
                                              child: const Text(
                                                'Change Church',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: PrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  });
                            },
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Posts and Replies",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(
                      color: BlackColor,
                    )
                  ],
                ),
              );
            },
          ),
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
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
