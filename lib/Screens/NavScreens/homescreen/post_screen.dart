import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/firestore/postDataChurch.dart';
import 'package:community/firestore/postDataMember.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController postTextController = TextEditingController();

  String userType = "Member";

  // int count = 0;

  // void addImages() {
  //   var photoStorage = FirebaseStorage.instance;

  //   List<String> image = [imageFile.toString()];

  //   image.forEach((element) async {
  //     String imageName = element
  //         .substring(element.lastIndexOf("/"), element.lastIndexOf("."))
  //         .replaceAll("/", "");

  //     String path = element.substring(element.indexOf("/") + 1, element.lastIndexOf("/"));

  //     final Directory systemTempDir = Directory.systemTemp;
  //     final byteData = await rootBundle.load(element);
  //     final file = File('${systemTempDir.path}/$imageName.jpeg');
  //     await file.writeAsBytes(byteData.buffer
  //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //     TaskSnapshot taskSnapshot =
  //         await photoStorage.ref('$path/$imageName').putFile(file);
  //     final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //     await FirebaseFirestore.instance
  //         .collection(path)
  //         .add({"url": downloadUrl, "name": imageName});
  //     count++;
  //     print(count);
  //   });

  // }

  // late File imageFile;

  // /// Get from gallery
  // getFromGallery() async {
  //   PickedFile? pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);
  //   }
  // }

  var churchInfo;
  var userInfo;
  var firstName;
  var lastName;
  var churchID;
  var churchName;

  Future getUserInfo() async {
    String userData = "";
    String userFirstName = "";
    String userLastName = "";
    String userChurchID = "";
    String userChurchName = "";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      userData = value.get('Status');
      userFirstName = value.get('First Name');
      userLastName = value.get('Last Name');
      userChurchID = value.get('Current Church ID');
    });

    setState(() {
      userInfo = userData;
      firstName = userFirstName;
      lastName = userLastName;
      churchID = userChurchID;
      churchName = userChurchName;
    });
  }

  Future getChurchInfo() async {
    String churchData = "";
    String churchDataName = "";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var data = await FirebaseFirestore.instance
        .collection('Churches')
        .doc(uid)
        .get()
        .then((value) {
      churchData = value.get('Status');
      churchDataName = value.get('Church Name');
    });

    setState(() {
      churchInfo = churchData;
      churchName = churchDataName;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
    getChurchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
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
                if (userType == userInfo) {
                  postDataMem(postTextController.text, userInfo, firstName,
                      lastName, churchID);
                } else {
                  postDataChu(postTextController.text, churchInfo, churchName);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
                //Fluttertoast.showToast(msg: "Post Successful!");
              },
              child: const Text(
                'Post to Church',
                style: TextStyle(color: PrimaryColor),
              ),
              shape: const CircleBorder(
                  side: BorderSide(color: Colors.transparent)),
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
