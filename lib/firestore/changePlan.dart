// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future editPlan(String churchID, int planCode) async {
  CollectionReference editPlan = FirebaseFirestore.instance.collection('edit');

  editPlan
    .doc()
    .set({
      'Church ID': churchID,
      'New Plan': planCode,
      'TimeStamp': FieldValue.serverTimestamp(),
    });


}