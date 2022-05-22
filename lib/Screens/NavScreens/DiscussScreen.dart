import 'package:flutter/material.dart';

class DiscussScreen extends StatefulWidget {
  const DiscussScreen({ Key? key }) : super(key: key);

  @override
  State<DiscussScreen> createState() => _DiscussScreenState();
}

class _DiscussScreenState extends State<DiscussScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      // ignore: prefer_const_constructors
      home: Scaffold(
        backgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }
}