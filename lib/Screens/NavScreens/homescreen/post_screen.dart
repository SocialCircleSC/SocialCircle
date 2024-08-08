// ignore_for_file: prefer_typing_uninitialized_variables, sort_child_properties_last

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:socialorb/screens/navscreens/navbar/nav_bar.dart';
import 'package:socialorb/firestore/postDataChurch.dart';
import 'package:socialorb/sizes/size.dart';

import 'package:socialorb/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  var profilePic;

  //Get the member's church ID
  Future getChurchID() async {
    String uID = "";
    // ignore: non_constant_identifier_names
    String ID = "";
    String fN = "";
    String lN = "";
    String stat = "";
    String pPic = "";

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
      pPic = value.get("ProfilePicture");
    });

    setState(() {
      churchID = ID;
      firstN = fN;
      lastN = lN;
      status = stat;
      userID = uID;
      profilePic = pPic;
    });

      await dotenv.load(fileName: "lib/.env");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchID();
  }

  late String imageUrl;
  late File videoFile;
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
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: BlackColor,
            ),
          ),

          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Destination"),
                        content:
                            const Text("Where would you like to post this?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (postTextController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please type a message or text");
                                } else {
                                  postDataChu(
                                      postTextController.text,
                                      status,
                                      profilePic,
                                      firstN,
                                      lastN,
                                      churchID,
                                      userID,
                                      imageList,
                                      type);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const NavBar()),
                                  );
                                  Fluttertoast.showToast(
                                      msg: "Post Successful!");
                                }
                              },
                              child: const Text("Church")),
                          TextButton(
                              onPressed: () {
                                if (postTextController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please type a message or text");
                                } else {
                                  postDataChu(
                                      postTextController.text,
                                      status,
                                      profilePic,
                                      firstN,
                                      lastN,
                                      dotenv.env['DISCOVER_CODE']!,
                                      userID,
                                      imageList,
                                      type);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const NavBar()),
                                  );
                                  Fluttertoast.showToast(
                                      msg: "Post Successful!");
                                }
                              },
                              child: const Text("Discover")),
                        ],
                      );
                    });
              },
              child: const Text(
                'Post',
                style: TextStyle(color: BlackColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ],
        ),

        // ignore: prefer_const_constructors
        body: Padding(
          // ignore: prefer_const_constructors
          padding: EdgeInsets.all(8.0),
          // ignore: prefer_const_constructors
          child: SingleChildScrollView(
              child: Wrap(
            children: [
              Row(
                children: [
                  //For Image

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                    ),
                    label: const Text("Add Image",
                      style: TextStyle(color: BlackColor),
                    ),
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (imageList.isEmpty) {
                        ImagePicker imagePicker = ImagePicker();
                        List<XFile>? file = await imagePicker.pickMultiImage();
                        if (file.length > 15) {
                          Fluttertoast.showToast(
                              msg: "The max number of photos is 15. You have ${file.length}",
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          setState(() {
                            for (int p = 0; p < file.length; p++) {
                              imageList.add(file[p].path);
                            }
                            type = "Image";
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
                      backgroundColor: PrimaryColor,
                    ),
                    label: const Text("Add Video",
                      style: TextStyle(color: BlackColor)
                    ),
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (imageList.isEmpty) {
                        final imagePicker = ImagePicker();
                        final file = await imagePicker.pickVideo(
                            source: ImageSource.gallery);

                        const fileSizeLimit = 250000000; //In Bytes
                        final fileSize = await file!.length();

                        if (fileSize >= fileSizeLimit) {
                          Fluttertoast.showToast(
                              msg:
                                  "The file is too big, please pick a smaller video",
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          setState(() {
                            imageList.add(File(file.path));
                            type = "Video";
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
                ],
              ),
              if (type == "Image")
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
                                        fit: BoxFit.cover,
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
              if (type == "Video")
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: displayHeight(context) * 0.55,
                    width: displayWidth(context),
                    child: Chewie(
                      controller: ChewieController(
                        videoPlayerController:
                            VideoPlayerController.file(imageList[0])
                              ..initialize(),
                      ),
                    ),
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
          )),
        ),
      ),
    );
  }
}
