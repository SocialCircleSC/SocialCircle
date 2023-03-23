import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/homescreen/bigger_picture.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/firestore/postDataChurch.dart';
import 'package:community/sizes/size.dart';
import 'package:community/storage/storage_services.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  var picturePath = [];

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

  late String imageUrl;
  var imageList = [];
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
                if (postTextController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please type a message or text");
                } else {
                  // postDataChu(postTextController.text, status, firstN, lastN,
                  //     churchID, userID, picturePath); Need to make picture path an array
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NavBar()),
                  );
                  Fluttertoast.showToast(msg: "Post Successful!");
                }
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
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      List<XFile>? file = await imagePicker.pickMultiImage();

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      setState(() {
                        for (int p = 0; p < file.length; p++) {
                          imageList.add(File(file[p].path));
                        }
                      });

                      Reference ref = FirebaseStorage.instance
                          .ref()
                          .child('/Users')
                          .child('/Churches')
                          .child('/$churchID')
                          .child(uniqueFileName);

                      try {
                        for (int i = 0; i < file.length; i++) {
                          await ref.putFile(File(file[i].path));
                        }

                        picturePath.add(await ref.getDownloadURL());
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                  const Text("Add Image")
                ],
              ),
              if (imageList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            height: displayHeight(context) * 0.35,
                            enableInfiniteScroll: true,
                            reverse: true,
                          ),
                          items: imageList.map<Widget>(((e) {
                            return Builder(builder: (BuildContext context) {
                              return GestureDetector(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.file(
                                        e, // File(e!.path),
                                        width: displayWidth(context) * 0.9,
                                        height: displayHeight(context) * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageList.remove(e);
                                        });
                                        
                                      },
                                      child: const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          })).toList())
                    ],
                  ),
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
