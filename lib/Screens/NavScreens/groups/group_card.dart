// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';

class GroupCard extends StatefulWidget {
  const GroupCard({Key? key}) : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
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

        if (mounted) {
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

        if (mounted) {
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
                SizedBox(
                  height: displayHeight(context) * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     ElevatedButton(
                          child: Text("Circle", style: TextStyle(color: PrimaryColor),),
                          
                          //pressAttention is intially false
                          onPressed: () {}),
                      ElevatedButton(
                          child: Text("Groups", style: TextStyle(color: Colors.black),),
                          
                          //pressAttention is intially false
                          onPressed: () {}),
                    ],
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.75,
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
                                          icon:
                                              Icon(Icons.keyboard_arrow_down),
                                          onChanged: (String? newValue) {
                                            dropdownvalue = newValue!;
                                            if (newValue == items[0]) {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const EditPost()),
                                              // );
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
                                                          onPressed: () {},
                                                        ),
                                                        TextButton(
                                                          child: Text("No"),
                                                          onPressed: () {},
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
