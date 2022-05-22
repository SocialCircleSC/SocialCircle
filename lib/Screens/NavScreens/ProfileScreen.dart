import 'package:community/Screens/AuthScreens/Login/LoginScreen.dart';
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
    return MaterialApp(
      // ignore: prefer_const_constructors
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: Text("LogOut")),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }

  //logout button
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
