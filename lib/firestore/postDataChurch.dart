import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

Future<void> postDataChu(String postText, String status, String fName,
    String lName, String churchID, String userID, List path, String type) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  var picturePath = [];

  for (int i = 0; i < path.length; i++) {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('/Users')
        .child('/Churches')
        .child('/$churchID')
        .child(uniqueFileName);

    try {
      await ref.putFile(File(path[i]));
      picturePath.add(await ref.getDownloadURL());
    } catch (e) {
      debugPrint("THIS ISNT WORKING WHY!");
    }
  }

  await FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('posts')
      .add({
    'First Name': fName,
    'Last Name': lName,
    'ID': uid,
    'Text': postText,
    'Status': status,
    'LikedBy': [],
    'Picture': picturePath,
    'Type': type,
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}
