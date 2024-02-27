import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> removeMemberMessage(String churchID, String userID, String messageID) async{

  //Add new memeber
  await FirebaseFirestore.instance
    .collection("circles")
    .doc(churchID)
    .collection("messages")
    .doc(messageID)
    .update({
      "Members": FieldValue.arrayRemove([userID])
    });
}