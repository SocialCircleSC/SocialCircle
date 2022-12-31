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
            return Container(
              height: displayHeight(context) * 0.8,
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: displayHeight(context) * 0.1),
                      child: Container(
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
                              title: Text(document['Name']),
                              subtitle: Text(
                                document['Status'],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  document['Post Text'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
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
                                      onTap: onLikeButtonTapped,
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
                                      likeCount: document['Likes'],
                                      countBuilder:
                                          (count, bool isLiked, String text) {
                                        var color = isLiked
                                            ? PrimaryColor
                                            : Colors.blueGrey;
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
                }).toList(),
              ),
            );
          }),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    //if isLiked = true, then add 1 to the likes
    //if isLiked = false, then substract 1 from the likes

    var collection = FirebaseFirestore.instance
      .collection("Churches")
      .doc(churchID)
     .collection("Posts")
      .doc()//get the document ID
      .update({'key' : 'value'}) // <-- Updated data
      .then((_) => print('Success'))
      .catchError((error) => print('Failed: $error'));

    return !isLiked;
  }
}






  // //Get Posts
  // Future getPosts() async {
  //   int counter = 0;
  //   List<Map<String, dynamic>> tempPostData = [];
  //   var random;

  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   final uid = user?.uid;

  //   var postData = await FirebaseFirestore.instance
  //       .collection('Churches')
  //       .doc(churchID)
  //       .collection("Posts")
  //       .get()
  //       .then((QuerySnapshot snapShot) {
  //     for (var element in snapShot.docs) {
  //       if (element.exists) {
  //         print("Collection Exists!!!!");
  //         print(element['Name']);
  //         random = element['Name'];
  //         // tempPostData.add({"Name" + counter.toString(): element['Name']});
  //         // tempPostData.add({"Post": element['Post Text']});
  //         // tempPostData.add({"Status": element['Status']});
  //         // tempPostData.add({"Likes": element['Likes']});
  //         print("Where the error is.");
  //       }
  //     }
  //   });

  //   if (this.mounted) {
  //     setState(() {
  //       postData = tempPostData;
  //       randomData = random;
  //     });
  //   }
  // }