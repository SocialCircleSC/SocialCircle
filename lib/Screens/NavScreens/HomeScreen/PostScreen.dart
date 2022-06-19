import 'package:community/Screens/NavScreens/NavBar/NavBar.dart';
import 'package:community/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
                Fluttertoast.showToast(msg: "Post Successful!");
              },
              child: const Text(
                'Post to Church',
                style: TextStyle(color: PrimaryColor),
              ),
              shape:
                  const CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
    
        // ignore: prefer_const_constructors
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          // ignore: prefer_const_constructors
          child: TextField(
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
        ),
      ),
    );
  }
}
