import 'package:community/firestore/updateDataChurch.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";

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
  late TextEditingController postTextController = TextEditingController(text: widget.textField);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: const Text('The System Back Button is Deactivated')));
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
            FlatButton(
              textColor: Colors.white,
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
