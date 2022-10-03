// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/Screens/NavScreens/HomeScreen/CardData.dart';
import 'package:community/Screens/NavScreens/Profile/ProfileScreen.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _posts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: FutureBuilder(
          future: Future.wait([
            //getUserInfo(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          return CardData();
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
