// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNewStat(String churchID, String status) async {
  //Change Status
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .update({
        "ListStatus": FieldValue.arrayUnion([status]),
      }   
      );
}