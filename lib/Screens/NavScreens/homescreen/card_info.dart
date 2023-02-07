// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:favorite_button/favorite_button.dart';

class CardInfo extends StatefulWidget {
  const CardInfo({Key? key}) : super(key: key);

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  // Initial Selected Value
  String dropdownvalue = 'Edit';

  // List of items in our dropdown menu
  var items = [
    'Edit',
    'Delete',
  ];

  String collection = "circles";
  String subCollection = "posts";
  bool switchState = false;
  var useID;
  //Get Church ID
  var churchID;
  List<Map<String, dynamic>> postData = [];
  var randomData;
  bool exist = false;

  //Get the member's church ID
  Future getChurchID() async {
    String ID = "";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((doc) {
        setState(() {
          exist = true;
        });
      });
      if (exist = true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((value) {
          ID = value.get('Church ID');
        });

        if (this.mounted) {
          setState(() {
            churchID = ID;
            //memID = uid;
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection('circles')
            .doc(uid)
            .get()
            .then((value) {
          ID = value.get('Church ID');
        });

        if (this.mounted) {
          setState(() {
            churchID = ID;
            //memID = ID;
          });
        }
      }
    } catch (e) {
      debugPrint("There is an error somewhere");
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
          //change here
          stream: FirebaseFirestore.instance
              .collection(collection)
              .doc(churchID)
              .collection(subCollection)
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
              children: [
                Container(
                  height: displayHeight(context) * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          child: Text("Circle"),
                          shape: Border(
                              bottom:
                                  BorderSide(color: PrimaryColor, width: 3)),
                          textColor: Colors.black,
                          //pressAttention is intially false
                          onPressed: () {}),
                      FlatButton(
                          child: Text("Groups"),
                          shape: Border(
                              bottom:
                                  BorderSide(color: Colors.white, width: 3)),
                          textColor: Colors.black,
                          //Intiallly is true
                          onPressed: () {}),
                    ],
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.75,
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
                                  padding: const EdgeInsets.all(16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      document['Text'],
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: displayHeight(context) * 0.01,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: FavoriteButton(
                                          isFavorite: document['Like Status'],
                                          iconSize: 35,
                                          // iconDisabledColor: Colors.white,
                                          valueChanged: (_isFavorite) {
                                            onFavButtonTapped(
                                                document['ID'],
                                                document['Likes'],
                                                document['Like Status']);
                                            debugPrint(
                                                'Is Favorite : $_isFavorite');
                                          },
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: document['Likes'].toString(),
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 90),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 90),
                                        child: DropdownButton(
                                          style: TextStyle(
                                                  color: BlackColor,
                                                  fontSize: 12),
                                            value: dropdownvalue,
                                            iconSize: 20,
                                            items: items.map((String items) {
                                              //This is where you can check for status and stuff like that to drop down or not
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  Future<void> onFavButtonTapped(
      String id, int numLikes, bool likeStatus) async {
    // if isLiked = true, then add 1 to the likes
    // if isLiked = false, then substract 1 from the likes
    if (likeStatus == false) {
      FirebaseFirestore.instance
          .collection("circles")
          .doc(churchID)
          .collection("posts")
          .doc(id) //get the document ID
          .update(
              {'Likes': numLikes + 1, 'Like Status': true}) // <-- Updated data
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      FirebaseFirestore.instance
          .collection("circles")
          .doc(churchID)
          .collection("posts")
          .doc(id) //get the document ID
          .update(
              {'Likes': numLikes - 1, 'Like Status': false}) // <-- Updated data
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
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