import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({ Key? key }) : super(key: key);

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      
      child: MaterialApp(
        // ignore: prefer_const_constructors
        home: Scaffold(
          backgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
  }
}