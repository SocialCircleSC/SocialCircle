import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:socialorb/firestore/updateDataChurch.dart';
import 'package:socialorb/screens/navscreens/navbar/nav_bar.dart';
import 'package:socialorb/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../sizes/size.dart';

class EditPost extends StatefulWidget {
  // Church ID, First Name, Last Name, Status
  final String circleID;
  final String fName;
  final String lName;
  final String status;
  final String docID;
  final String textField;

  const EditPost(
      {Key? key,
      required this.circleID,
      required this.fName,
      required this.lName,
      required this.status,
      required this.docID,
      required this.textField})
      : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late TextEditingController postTextController =
      TextEditingController(text: widget.textField);

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

          // ignore: prefer_const_literals_to_create_immutables
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, elevation: 0),
              onPressed: () {
                updatePost(
                    widget.circleID, postTextController.text, widget.docID);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
              },
              child: const Text(
                'Edit Post',
                style: TextStyle(color: PrimaryColor),
              ),
            ),
          ],
        ),

        // ignore: prefer_const_constructors
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          // ignore: prefer_const_constructors
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SecondaryColor,
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
                      backgroundColor: SecondaryColor,
                    ),
                    label: const Text("Add Video"),
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
              TextFormField(
                controller: postTextController,
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  //hintText: "What would you like to say?",
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
