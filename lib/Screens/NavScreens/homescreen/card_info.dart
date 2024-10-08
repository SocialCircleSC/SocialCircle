// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialorb/firestore/delete_post.dart';
import 'package:socialorb/screens/navscreens/homescreen/bigger_picture.dart';
import 'package:socialorb/screens/navscreens/homescreen/comments_screen.dart';
import 'package:socialorb/screens/navscreens/homescreen/edit_post.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';


class CardInfo extends StatefulWidget {
  const CardInfo({Key? key}) : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  // Initial Selected Value
  String? dropdownvalue;
  String collect = " ";
  String collectID = " ";

  bool likeStatus = false;

  // List of items in our dropdown menu
  var items = [
    'Edit',
    'Delete',
  ];

  bool switchState = false;

  bool buttonColor = true;
  //Get Church ID
  var churchID;
  var userID;
  var profilePic;
  var userName;
  var temp;
  var temp2 = "7PEVPi7V6VU7fMsXCA5X0m8crxj2";

  //Get the member's church ID
  Future getChurchID() async {
    String cID = "";
    String pPic = "";
    String uName = "";

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
      pPic = value.get('ProfilePicture');
      //uName = value.get("First Name");
    });

    setState(() {
      churchID = cID;
      temp = cID;
      userID = uid;
      profilePic = pPic;
      userName = uName;
    });
  }

  @override
  void didChangeDependencies() {
    getChurchID();
    super.didChangeDependencies();
  }

  var chewieController;
  var vController = VideoPlayerController.networkUrl(Uri.parse(
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Users%2FChurches%2FGhKxRVYOhaaapZPbEmsMsFOFImN2%2F1687226151192435?alt=media&token=4e77a65a-25fe-4663-ac15-46ff90fd22f8"))
    ..initialize();
  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(videoPlayerController: vController);
  }

  @override
  void dispose() {
    vController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (churchID == null) {
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
          //change here
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID) //should not be set in the build
              .collection("posts")
              .limit(200)
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
            return SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 110),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (buttonColor == true) {
                                      setState(() {
                                        churchID = temp2;
                                        buttonColor = !buttonColor;
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0),
                                child: Text(
                                  "Discover",
                                  style: TextStyle(
                                      color: buttonColor
                                          ? BlackColor
                                          : PrimaryColor),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (buttonColor == false) {
                                      setState(() {
                                        churchID = temp;
                                        buttonColor = !buttonColor;
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                      color: buttonColor
                                          ? PrimaryColor
                                          : BlackColor),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: displayHeight(context) * 0.84,
                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Column(
                          children: [
                            Card(
                              color: Colors.white,
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
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: BlackColor),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage(document[
                                                    "ProfilePicture"]))),
                                      ),
                                      title: Text(document['First Name'] +
                                          " " +
                                          document['Last Name']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          document['Text'],
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.8)),
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
                                                        displayHeight(context) *
                                                            0.55,
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
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              child:
                                                                  Image.network(
                                                                e,
                                                                width:
                                                                    displayWidth(
                                                                        context),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            if (document[
                                                                        'Picture']
                                                                    .length !=
                                                                1)
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    AnimatedSmoothIndicator(
                                                                  activeIndex: document[
                                                                          "Picture"]
                                                                      .indexWhere(
                                                                          (f) =>
                                                                              f ==
                                                                              e),
                                                                  count: document[
                                                                          'Picture']
                                                                      .length,
                                                                  effect:
                                                                      const ScrollingDotsEffect(
                                                                    dotHeight:
                                                                        7,
                                                                    dotWidth: 7,
                                                                    activeDotScale:
                                                                        1.5,
                                                                  ),
                                                                ),
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
                                          height: displayHeight(context) * 0.6,
                                          width: displayWidth(context),
                                          child: Chewie(
                                            controller: ChewieController(
                                                videoPlayerController:
                                                    VideoPlayerController
                                                        .networkUrl(Uri.parse(
                                                            document["Picture"]
                                                                [0]))
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

                                                  List likedusers =
                                                      post["LikedBy"];
                                                  if (likedusers.contains(
                                                          userID.toString()) ==
                                                      true) {
                                                    postDoc.update({
                                                      "LikedBy": FieldValue
                                                          .arrayRemove([userID])
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
                                                              .contains(
                                                                  userID) ==
                                                          true
                                                      ? Colors.red
                                                      : Colors.grey,
                                                )),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: getLikeCount(
                                                  document['LikedBy']),
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Comments(
                                                            churchID: churchID,
                                                            firstName: document[
                                                                'First Name'],
                                                            lastName: document[
                                                                'Last Name'],
                                                            likeStatus:
                                                                getLikeStatus(
                                                                    document[
                                                                        'LikedBy'],
                                                                    userID),
                                                            likes: document[
                                                                    'LikedBy']
                                                                .length
                                                                .toString(),
                                                            pictureLength:
                                                                document[
                                                                        'Picture']
                                                                    .length,
                                                            postID: document.id,
                                                            postPicture:
                                                                document[
                                                                    'Picture'],
                                                            postVideo: document[
                                                                'Picture'],
                                                            profilePic: document[
                                                                'ProfilePicture'],
                                                            status: document[
                                                                'Status'],
                                                            text: document[
                                                                'Text'],
                                                            type: document[
                                                                'Type'],
                                                            userID: userID,
                                                            likesArr: document[
                                                                'LikedBy'],
                                                          )));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 90),
                                              child: RichText(
                                                text: TextSpan(
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.comment_outlined,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "     " "0",
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (document["ID"] == userID)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 90),
                                              child: DropdownButton(
                                                  style: TextStyle(
                                                      color: BlackColor,
                                                      fontSize: 12),
                                                  value: dropdownvalue,
                                                  hint: Text("More"),
                                                  iconSize: 20,
                                                  items:
                                                      items.map((String items) {
                                                    //This is where you can check for status and stuff like that to drop down or not
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                  icon: Icon(Icons
                                                      .keyboard_arrow_down),
                                                  onChanged:
                                                      (String? newValue) {
                                                    if (newValue == items[0]) {
                                                      _goToEditScreen(
                                                          context,
                                                          churchID,
                                                          document[
                                                              'First Name'],
                                                          document['Last Name'],
                                                          document['Status'],
                                                          document['Text'],
                                                          document.id);
                                                    } else if (newValue ==
                                                        items[1]) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Confirm"),
                                                              content: Text(
                                                                  "Are you sure you want to delete this post?"),
                                                              actions: [
                                                                TextButton(
                                                                  child: Text(
                                                                      "Yes"),
                                                                  onPressed:
                                                                      () {
                                                                    deletePost(
                                                                        document
                                                                            .id,
                                                                        churchID,
                                                                        document[
                                                                            "Picture"]);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                      "No"),
                                                                  onPressed:
                                                                      () {
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
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
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
