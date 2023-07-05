// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/messaging/new_message.dart';
import 'package:community/screens/messaging/specific_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../themes/theme.dart';

class MessageHome extends StatefulWidget {
  const MessageHome({super.key});

  static const route = '/community/screens/messaging/message_home.dart';

  @override
  State<MessageHome> createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  String churchID = "";
  String userID = "";
  String name = "";
  String combName = "";
  Future getCurrentChurch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var cID;
    var uID;
    var fName;
    var lName;
    //Get ChurchID
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
      uID = value.get("ID");
      fName = value.get("First Name");
      lName = value.get("Last Name");
    });

    setState(() {
      churchID = cID;
      userID = uID;
      combName = fName + " " + lName;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentChurch();
  }

  @override
  Widget build(BuildContext context) {
    if (churchID.isEmpty) {
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: BlackColor,
            ),
          ),
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search Members",
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewMessage(
                          churchID: churchID,
                          userID: userID,
                          combName: combName,
                        )));
          },
          child: const Icon(Icons.message),
          backgroundColor: PrimaryColor,
          foregroundColor: WhiteColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .collection("messages")
              .where("Members", arrayContains: userID)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  if (name.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // ignore: unused_local_variable
                          bool sender = false;
                          if (userID == data["Creator"]) {
                            sender = true;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpecificMessage(
                                        churchID: churchID,
                                        userID: userID,
                                        documentID:
                                            snapshot.data!.docs[index].id,
                                        name: combName,
                                        sender: userID,
                                        title: data['Title'],
                                      )));
                        },
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(width: 4, color: BlackColor),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(data["Image"]))),
                          ),
                          title: Text(data["Title"]),
                          subtitle: Text(
                            data['Text'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            DateFormat("h:mma").format(
                                (data["TimeStamp"] as Timestamp).toDate()),
                          ),
                        ),
                      ),
                    );
                  }

                  if (data['Title']
                      .toString()
                      .toLowerCase()
                      .contains(name.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          
                          // ignore: unused_local_variable
                          bool sender = false;
                          if (userID == data["Creator"]) {
                            sender = true;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpecificMessage(
                                        churchID: churchID,
                                        userID: userID,
                                        documentID:
                                            snapshot.data!.docs[index].id,
                                        name: combName,
                                        sender: userID,
                                        title: data['Title'],
                                      )));
                        },
                        child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: BlackColor),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(data["Image"]))),
                            ),
                            title: Text(data["Title"]),
                            subtitle: Text(
                              data['Text'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              DateFormat("h:mma").format(
                                  (data["TimeStamp"] as Timestamp).toDate()),
                            )),
                      ),
                    );
                  }

                  return Container();
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<String> getText(String docID) async {
    String retString = "Hi";
    QuerySnapshot info = await FirebaseFirestore.instance
        .collection('circles')
        .doc(churchID)
        .collection('messages')
        .doc(docID)
        .collection('interactions')
        .orderBy("TimeStamp", descending: true)
        .limit(1)
        .get();

    for (var element in info.docs) {
      setState(() {
        retString = element["Text"];
      });
    }
    return retString;
  }
}



