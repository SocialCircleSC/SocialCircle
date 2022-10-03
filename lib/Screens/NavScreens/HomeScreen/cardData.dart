// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class CardData extends StatefulWidget {
  const CardData({Key? key}) : super(key: key);

  @override
  State<CardData> createState() => _CardDataState();
}

class _CardDataState extends State<CardData> {
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

  //Get Posts
  Future getPosts() async {
    int counter = 0;
    List<Map<String, dynamic>> tempPostData = [];
    var random;

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var postData = await FirebaseFirestore.instance
        .collection('Churches')
        .doc(churchID)
        .collection("Posts")
        .get()
        .then((QuerySnapshot snapShot) {
      for (var element in snapShot.docs) {
        if (element.exists) {
          print("Collection Exists!!!!");
          print(element['Name']);
          random = element['Name'];
          // tempPostData.add({"Name" + counter.toString(): element['Name']});
          // tempPostData.add({"Post": element['Post Text']});
          // tempPostData.add({"Status": element['Status']});
          // tempPostData.add({"Likes": element['Likes']});
          print("Where the error is.");
        }
      }
    });

    if (this.mounted) {
      setState(() {
        postData = tempPostData;
        randomData = random;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchID();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: FutureBuilder(
          future: Future.wait([
            getChurchID(),
            getPosts(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/fp_profile.jpg'),
                      ),
                      title: Text(
                        randomData,
                        //postData[0].values.toString(),
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Member',
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: Text(
                            "Good afternoon church! Thank you so much for being with us! See you all next week!",
                            style: TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        //Padding(padding: EdgeInsets.symmetric(vertical: 60)),
                        Expanded(
                          child: Image.network(
                            'https://googleflutter.com/sample_image.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 25,
                        ),
                        LikeButton(
                          circleColor: CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: SecondaryColor,
                            dotSecondaryColor: SecondaryColor,
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.thumb_up,
                              color: isLiked ? PrimaryColor : Colors.blueGrey,
                              size: 15,
                            );
                          },
                          likeCount: 665,
                          countBuilder: (count, bool isLiked, String text) {
                            var color =
                                isLiked ? PrimaryColor : Colors.blueGrey;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "love",
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
                        SizedBox(
                          width: 70,
                        ),
                        Expanded(
                            child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.comment,
                                  color: Colors.blueGrey,
                                  size: 15,
                                ),
                                label: const Text(
                                  "Comment",
                                  style: TextStyle(color: Colors.blueGrey),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
