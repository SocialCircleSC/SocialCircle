import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../firestore/delete_post.dart';
import '../homescreen/bigger_picture.dart';
import '../homescreen/comments_screen.dart';
import '../homescreen/edit_post.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({Key? key}) : super(key: key);

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  //getChurchInfo
  String churchID = "";
  String userID = "";
  String firstName = "";
  String lastName = "";
  String status = "";
  var list;

  Future getCurrentChurch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var cID;
    var fireList;
    var fName;
    var lName;
    var stat;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
    });

    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .get()
        .then((value) {
      fireList = value.get('Pictures');
      fName = value.get("First Name");
      lName = value.get("Last Name");
      stat = value.get("Status");
    });

    setState(() {
      churchID = cID;
      userID = uid.toString();
      list = fireList;
      firstName = fName;
      lastName = lName;
      status = stat;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentChurch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? dropdownvalue;
  // List of items in our dropdown menu
  var items = [
    'Edit',
    'Delete',
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .collection("posts")
              .limit(25)
              .orderBy('TimeStamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting ||
                snapshot1.connectionState == ConnectionState.none) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return SingleChildScrollView(
                child: Wrap(
              children: <Widget>[
                CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      height: 300,
                    ),
                    items: list.map<Widget>(((e) {
                      return Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BiggerPicture(picture: e)));
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  e,
                                  width: displayWidth(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              AnimatedSmoothIndicator(
                                activeIndex: list.indexWhere((f) => f == e),
                                count: list.length,
                              ),
                            ],
                          ),
                        );
                      });
                    })).toList()),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    firstName + " " + lastName,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: WhiteColor,
                        backgroundColor: SecondaryColor,
                      ),
                      child: const Text("Members"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  children: [
                                    // ListView(
                                    //   children: ,
                                    // )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (userID == churchID)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: WhiteColor,
                          backgroundColor: SecondaryColor,
                        ),
                        child: const Text("Edit"),
                        onPressed: () {},
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: BlackColor,
                  indent: 10,
                  endIndent: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Weekly Activities",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // ListView.builder(
                //     itemCount: document["EventsCount"],
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: document["Hours"][index],
                //       );
                //     }),
              ],
            ));
          }),
    );
  }
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
