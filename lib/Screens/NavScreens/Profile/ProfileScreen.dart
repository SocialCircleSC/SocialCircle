import 'package:community/Screens/AuthScreens/Login/LoginScreen.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Padding(
                  padding: CenterPadding2,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/holderimage.jpg'),
                    radius: 50,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Olaoluwa Olojede",
                  style: TextStyle(
                    color: BlackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "The Grace of God Ministries",
                  style: TextStyle(
                    color: BlackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: LeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Status: " + "Member",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: LeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About Me: " + "Hi",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Posts and Replies",
                  style: TextStyle(
                    color: BlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: BlackColor,
                )
              ],
            ),
          ),
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
  }

  //logout button
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}


// Column(
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     logout(context);
//                   },
//                   child: Text("LogOut")),
//             ],
//           ),