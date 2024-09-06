// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future deleteChurch(String churchID) async {
  CollectionReference deleteCircle = FirebaseFirestore.instance.collection('delete');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  deleteCircle
    .doc()
    .set({
      'Church ID': churchID,
      'TimeStamp': FieldValue.serverTimestamp(),
    });


}
