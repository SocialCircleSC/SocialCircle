import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:community/storage/storage_services.dart';
import 'package:community/sizes/size.dart';

import '../../../AuthScreens/Login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  String imagePath = 'lib/assets/holderimage.jpg';

  List<Map<String, dynamic>> userInfo = [];

  Future getUserInfo() async {
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
    final Storage storage = Storage();
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

                    FutureBuilder(
                        future: storage.downloadURL('20220806_143654.jpg'),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Padding(
                              padding: CenterPadding3,
                              child: SizedBox(
                                width: displayWidth(context) * 0.1,
                                height: displayHeight(context) * 0.1,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  radius: 50,
                                ),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          return Container();
                        }),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
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
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: LeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Status: " "" +
                              removeParenthese(userInfo[4].values.toString()),
                          
                          style: const TextStyle(
                            color: BlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
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
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    
                    SizedBox(
                      height: displayHeight(context) * 0.01,
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
