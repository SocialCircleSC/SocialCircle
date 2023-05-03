import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> updateChurchPictures(
    String pic1, String pic2, String pic3, String churchID) async {
  DocumentReference postToCircle =
      FirebaseFirestore.instance.collection('circles').doc(churchID);

  //For Pic1
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

  Reference ref = FirebaseStorage.instance
      .ref()
      .child('/Users')
      .child('/Churches')
      .child('/$churchID')
      .child(uniqueFileName);

  try {
    await ref.putFile(File(pic1));
    pic1 = await ref.getDownloadURL();
  } catch (e) {
    debugPrint("THIS ISNT WORKING WHY!");
  }

  //For Pic2

  Future.delayed(const Duration(microseconds: 500), (() async {
    String uniqueFileName2 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference ref2 = FirebaseStorage.instance
        .ref()
        .child('/Users')
        .child('/Churches')
        .child('/$churchID')
        .child(uniqueFileName2);

    try {
      await ref2.putFile(File(pic2));
      pic2 = await ref2.getDownloadURL();
    } catch (e) {
      debugPrint("THIS ISNT WORKING WHY!");
    }
  }));

  //For Pic3

  Future.delayed(const Duration(microseconds: 500), (() async {
    String uniqueFileName3 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference ref3 = FirebaseStorage.instance
        .ref()
        .child('/Users')
        .child('/Churches')
        .child('/$churchID')
        .child(uniqueFileName3);

    try {
      await ref3.putFile(File(pic3));
      pic3 = await ref3.getDownloadURL();
    } catch (e) {
      debugPrint("THIS ISNT WORKING WHY!");
    }

    postToCircle.update({'Pictures': []});

    postToCircle.update({
      'Pictures': FieldValue.arrayUnion([pic1, pic2, pic3])
    });
  }));
}
