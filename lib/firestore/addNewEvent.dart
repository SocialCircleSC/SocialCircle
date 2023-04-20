import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNewEven(String churchID, String event) async {
  //Change Status
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .update({
        "Events": FieldValue.arrayUnion([event]),
      }   
      );
}