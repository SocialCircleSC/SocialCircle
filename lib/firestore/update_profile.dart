// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> updateProfile(String userID, String fName, String lName,
    String email, String password, String about, String image) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  String pic = "";
  DocumentReference postToCircle =
      FirebaseFirestore.instance.collection('users').doc(userID);

  //First Name
  if (fName.isNotEmpty) {
    postToCircle.update({
      'First Name': fName,
    });
  }

  //Last Name
  if (lName.isNotEmpty) {
    postToCircle.update({
      'Last Name': lName,
    });
  }

  //About Me
  if (about.isNotEmpty) {
    postToCircle.update({
      'About': about,
    });
  }

  //ProfilePicture
  if (image.isNotEmpty) {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('/Users')
          .child('/Churches')
          .child('/$userID')
          .child(uniqueFileName);

      try {
        await ref.putFile(File(image));
        pic = await ref.getDownloadURL();
      } catch (e) {
        debugPrint("THIS ISNT WORKING WHY!");
      }

    postToCircle.update({
      'ProfilePicture': pic,
    });
  }


  //Email
  if (email.isNotEmpty) {
    postToCircle.update({
      'Email Address': email,
    });
    user!.updateEmail(email).then((value) => null);
  }

  //Password
  if (password.isNotEmpty) {
    user!.updatePassword(password).then((value) => null);
  }
}
