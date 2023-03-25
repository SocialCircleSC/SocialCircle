import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/firestore/postDataChurch.dart';
import 'package:community/sizes/size.dart';

import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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

  late String imageUrl;
  var imageList = [];
  String type = "Text";
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
            ElevatedButton(
              
              onPressed: () {
                if (postTextController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please type a message or text");
                } else {
                  postDataChu(postTextController.text, status, firstN, lastN,
                      churchID, userID, imageList, type);
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
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
                  //For Image

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: SecondaryColor,
                    ),
                    label: const Text("Add Image"),
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (imageList.isEmpty) {
                        ImagePicker imagePicker = ImagePicker();
                        List<XFile>? file = await imagePicker.pickMultiImage();
                        if (file!.length > 15) {
                          Fluttertoast.showToast(
                              msg: "The max number of photos is 15. You have " +
                                  file.length.toString(),
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          setState(() {
                            type = "Image";
                            for (int p = 0; p < file.length; p++) {
                              imageList.add(file[p].path);
                            }
                          });
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Please remove the pictures or video you have below",
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                  ),

                  SizedBox(width: displayWidth(context) * 0.03),

                  //For Video

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: SecondaryColor,
                    ),
                    label: const Text("Add Video"),
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (imageList.isEmpty) {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickVideo(
                            source: ImageSource.gallery);

                        setState(() async {
                          type = "Video";
                          imageList.add(file!.path);
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Please remove the pictures or video you have below",
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                  ),
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
                            enableInfiniteScroll: false,
                            reverse: false,
                          ),
                          items: imageList.map<Widget>(((e) {
                            return Builder(builder: (BuildContext context) {
                              return GestureDetector(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.file(
                                        File(e), // File(e!.path),
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
