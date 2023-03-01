import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/firestore/postDataChurch.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController postTextController = TextEditingController();
  bool exist = false;
  var userID;
  var churchID;
  var firstN;
  var lastN;
  var status;
  var docID;

  //Get the member's church ID
  Future getChurchID() async {
    String uID = "";
    String ID = "";
    String fN = "";
    String lN = "";
    String stat = "";
    //String doc = "";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
          ID = value.get('Church ID');
          fN = value.get('First Name');
          lN = value.get('Last Name');
          stat = value.get('Status');
          uID = value.id;
    });

    setState(() {
      churchID = ID;
      firstN = fN;
      lastN = lN;
      status = stat;
      userID = uID;
    });

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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //title: const Text('Post to Church', style: TextStyle(color: PrimaryColor),),
          leading: IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: PrimaryColor,
            ),
          ),

          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                postDataChu(
                    postTextController.text, status, firstN, lastN, churchID, userID);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
                Fluttertoast.showToast(msg: "Post Successful!");
              },
              child: const Text(
                'Post',
                style: TextStyle(color: PrimaryColor),
              ),
              shape: const CircleBorder(
                  side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),

        // ignore: prefer_const_constructors
        body: Padding(
          // ignore: prefer_const_constructors
          padding: EdgeInsets.all(8.0),
          // ignore: prefer_const_constructors
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //getFromGallery();
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                  const Text("Add Image")
                ],
              ),
              TextField(
                controller: postTextController,
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: "What would you like to say?",
                  // ignore: prefer_const_constructors
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: PrimaryColor),
                  ),
                  // ignore: prefer_const_constructors
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: PrimaryColor),
                  ),
                  // ignore: prefer_const_constructors
                  border: UnderlineInputBorder(
                    borderSide: const BorderSide(color: PrimaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
