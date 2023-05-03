import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/sizes/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../themes/theme.dart';

class messageHome extends StatefulWidget {
  const messageHome({super.key});

  @override
  State<messageHome> createState() => _messageHomeState();
}

class _messageHomeState extends State<messageHome> {
  String churchID = "";
  String userID = "";
  Future getCurrentChurch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var cID;
    var uID;
    //Get ChurchID
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
      uID = value.get("ID");
    });

    setState(() {
      churchID = cID;
      userID = uID;
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
          title: const Text(
            "Messages",
            style: TextStyle(color: BlackColor),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(top: 12, right: 15),
              child: Icon(
                Icons.search,
                size: 28,
                color: BlackColor,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.message),
          backgroundColor: PrimaryColor,
          foregroundColor: WhiteColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .collection("members")
              .doc(userID)
              .collection("messages")
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
              return SingleChildScrollView(
                child: Wrap(
                  children: [
                    SizedBox(
                        height: displayHeight(context),
                        width: displayWidth(context),
                        child: ListView(
                          children: snapshot.data!.docs.map((document) {
                            return Column(
                              children: [
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight:
                                            displayHeight(context) * 0.1),
                                    child: Column(children: [
                                      SizedBox(
                                        height: displayHeight(context) * 0.01,
                                      ),
                                      ListTile(
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 4, color: BlackColor),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(
                                                      document["Image"]))),
                                        ),
                                        title: Text(document["Name"]),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
