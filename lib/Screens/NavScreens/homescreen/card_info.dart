// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:like_button/like_button.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({Key? key}) : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  //Get Church ID
  var churchID;
  List<Map<String, dynamic>> postData = [];
  var randomData;

  //Get the member's church ID
  Future getChurchID() async {
    String ID = "";

    String test = "Test";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      ID = value.get('Church ID');
    });

    if (this.mounted) {
      setState(() {
        churchID = ID;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchID();
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
              .collection("Churches")
              .doc(churchID)
              .collection("Posts")
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
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: displayHeight(context) * 0.1),
                child: Container(
                  //height: displayHeight(context) * 0.22,
                  child: Column(
                    children: [
                      SizedBox(
                        height: displayHeight(context) * 0.01,
                      ),
                      ListTile(
                        // ignore: prefer_const_constructors
                        leading: CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/fp_profile.jpg'),
                        ),
                        title: const Text("User's Name"),
                        subtitle: Text(
                          "User's Status",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Line length is determined by typographic parameters based on a formal grid and template with several goals in mind: balance and function for fit and readability with a sensitivity to aesthetic style in typography. Typographers adjust line length to aid legibility or copy fit. Text can be flush left and ragged right, flush right and ragged left, or justified where all lines are of equal length. In a ragged right setting, line lengths vary to create a ragged right edge. Sometimes this can be visually satisfying. For justified and ragged right settings typographers can adjust line length to avoid unwanted hyphens, rivers of white space, and orphaned words/characters at the end of lines (e.g., "The", "I", "He", "We").',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      // SizedBox(
                      //   height: displayHeight(context) * 0.01,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 96),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: LikeButton(
                                circleColor: const CircleColor(
                                    start: Color(0xff00ddff),
                                    end: Color(0xff0099cc)),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: SecondaryColor,
                                  dotSecondaryColor: SecondaryColor,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    Icons.thumb_up,
                                    color: isLiked
                                        ? PrimaryColor
                                        : Colors.blueGrey,
                                    size: 17,
                                  );
                                },
                                likeCount: 0,
                                countBuilder:
                                    (count, bool isLiked, String text) {
                                  var color =
                                      isLiked ? PrimaryColor : Colors.blueGrey;
                                  Widget result;
                                  if (count == 0) {
                                    result = Text(
                                      "",
                                      style: TextStyle(color: color),
                                    );
                                  } else {
                                    result = Text(
                                      text,
                                      style: TextStyle(color: color),
                                    );
                                  }
                                  return result;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 90),
                              child: RichText(
                                // ignore: prefer_const_constructors
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
