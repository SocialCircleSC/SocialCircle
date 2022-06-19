// ignore_for_file: prefer_const_constructors

import 'package:community/Screens/NavScreens/HomeScreen/cardData.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatelessWidget {
  final List _posts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return cardData();
              }),

              ),

        ],       
      ),
    );
  }
}
