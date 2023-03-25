// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/firestore/delete_post.dart';
import 'package:community/screens/navscreens/homescreen/bigger_picture.dart';
import 'package:community/screens/navscreens/homescreen/edit_post.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({Key? key}) : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  // Initial Selected Value
  String? dropdownvalue;
  String collect = "";
  String collectID = "";

  bool likeStatus = false;

  // List of items in our dropdown menu
  var items = [
    'Edit',
    'Delete',
  ];

  bool switchState = false;
  //Get Church ID
  var churchID;
  var userID;

  //Get the member's church ID
  Future getChurchID() async {
    String cID = "";

    //Get church ID
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
    });

    setState(() {
      churchID = cID;
      userID = uid;
    });
  }

  @override
  void didChangeDependencies() {
    getChurchID();
    super.didChangeDependencies();
  }

  late VideoPlayerController vController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: StreamBuilder(
          //change here
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .collection("posts")
              .limit(25)
              .orderBy('TimeStamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return Column(
              children: <Widget>[
                SizedBox(
                  height: displayHeight(context) * 0.84,
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: displayHeight(context) * 0.1),
                          child: Column(
                            children: [
                              SizedBox(
                                height: displayHeight(context) * 0.01,
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('lib/assets/fp_profile.jpg'),
                                ),
                                title: Text(document['First Name'] +
                                    " " +
                                    document['Last Name']),
                                subtitle: Text(
                                  document['Status'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    document['Text'],
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8)),
                                  ),
                                ),
                              ),
                              if (document["Type"] == "Image")
                                //Only show image if it exists
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Stack(
                                      children: [
                                        CarouselSlider(
                                            options: CarouselOptions(
                                              viewportFraction: 1,
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll: false,
                                              height:
                                                  displayHeight(context) * 0.35,
                                            ),
                                            items: document['Picture']
                                                .map<Widget>(((e) {
                                              return Builder(builder:
                                                  (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BiggerPicture(
                                                                    picture:
                                                                        e)));
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        child: Image.network(
                                                          e,
                                                          width: displayWidth(
                                                              context),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      if (document['Picture']
                                                              .length !=
                                                          1)
                                                        AnimatedSmoothIndicator(
                                                          activeIndex: document[
                                                                  "Picture"]
                                                              .indexWhere((f) =>
                                                                  f == e),
                                                          count: document[
                                                                  'Picture']
                                                              .length,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            })).toList()),
                                      ],
                                    ),
                                  ),
                                ),
                              if (document["Type"] == "Video")
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: displayHeight(context) * 0.5,
                                    width: displayWidth(context),
                                    child: Chewie(
                                      controller: ChewieController(
                                          videoPlayerController:
                                              VideoPlayerController.network(
                                                  document["Picture"][0])
                                                ..initialize()),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Row(
                                  children: <Widget>[
                                    Center(
                                      child: IconButton(
                                          onPressed: () async {
                                            DocumentReference postDoc =
                                                FirebaseFirestore.instance
                                                    .collection("circles")
                                                    .doc(churchID)
                                                    .collection("posts")
                                                    .doc(document.id);
                                            DocumentSnapshot post =
                                                await postDoc.get();

                                            List likedusers = post["LikedBy"];
                                            if (likedusers.contains(
                                                    userID.toString()) ==
                                                true) {
                                              postDoc.update({
                                                "LikedBy":
                                                    FieldValue.arrayRemove(
                                                        [userID])
                                              });
                                            } else {
                                              postDoc.update({
                                                "LikedBy":
                                                    FieldValue.arrayUnion(
                                                        [userID])
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: document["LikedBy"]
                                                        .contains(userID) ==
                                                    true
                                                ? Colors.red
                                                : Colors.grey,
                                          )),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: getLikeCount(document['LikedBy']),
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 90),
                                      child: RichText(
                                        text: TextSpan(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.comment_sharp,
                                                size: 20,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "0",
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 90),
                                      child: DropdownButton(
                                          style: TextStyle(
                                              color: BlackColor, fontSize: 12),
                                          value: dropdownvalue,
                                          hint: Text("More"),
                                          iconSize: 20,
                                          items: items.map((String items) {
                                            //This is where you can check for status and stuff like that to drop down or not
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          onChanged: (String? newValue) {
                                            if (newValue == items[0]) {
                                              _goToEditScreen(
                                                  context,
                                                  churchID,
                                                  document['First Name'],
                                                  document['Last Name'],
                                                  document['Status'],
                                                  document['Text'],
                                                  document.id);
                                            } else if (newValue == items[1]) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Confirm"),
                                                      content: Text(
                                                          "Are you sure you want to delete this post?"),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("Yes"),
                                                          onPressed: () {
                                                            deletePost(
                                                                document.id,
                                                                churchID,
                                                                document[
                                                                    "Picture"]);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text("No"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

String getLikeCount(document) {
  int likeCount = 0;
  var exMap;
  exMap = document;
  likeCount = exMap.length;
  return likeCount.toString();
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
