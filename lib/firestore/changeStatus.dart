import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> changeStat(String memberID, String churchID, String status) async {
  //Change Status
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("members")
      .doc(memberID)
      .update({
        "Status": status,
      }
       
      );
}
