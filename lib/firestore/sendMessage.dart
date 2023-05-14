import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
}
