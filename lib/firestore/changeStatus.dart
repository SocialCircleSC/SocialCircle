// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> changeStat(String memberID, String churchID, String status) async {
  if (status != "Visitor") {
    await FirebaseFirestore.instance
        .collection("circles")
        .doc(churchID)
        .update({'Number of Members': FieldValue.increment(1)});
  } else {
    await FirebaseFirestore.instance
        .collection("circles")
        .doc(churchID)
        .update({'Number of Members': FieldValue.increment(-1)});
  }
  //Change Status
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("members")
      .doc(memberID)
      .update({
    "Status": status,
  });
}
