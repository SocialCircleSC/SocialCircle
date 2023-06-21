// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendMessage(String churchID, String userID, String documentID,
    String type, String messageText, String name) async {
  //Add to interactions section
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("messages")
      .doc(documentID)
      .collection("interactions")
      .add({
    "Name": name,
    "Sender": userID,
    "Type": type,
    "Text": messageText,
    "TimeStamp": FieldValue.serverTimestamp(),
  });

  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("messages")
      .doc(documentID)
      .update({
    'Text': messageText,
  });
}
