import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteStat(String churchID, String status) async {
  //Change Status
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .update({
        "ListStatus": FieldValue.arrayRemove([status]),
      }   
      );
}