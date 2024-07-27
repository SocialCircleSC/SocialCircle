// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createGroup(
    String churchID, String userID, List groupMembers, String groupName) async {
  //Add to messages section
  DocumentReference docRef = await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("messages")
      .add({
    "Creator": userID,
    "Message ID": " ",
    "Image":
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    "Text": "Start the conversation",
    "Title": groupName,
    "Members": FieldValue.arrayUnion(groupMembers),
    "TimeStamp": FieldValue.serverTimestamp(),
    "Type": "text"
  });

  docRef;

  await FirebaseFirestore.instance
          .collection("circles")
          .doc(churchID)
          .collection("messages")
          .doc(docRef.id)
          .update({
        "Message ID": docRef.id,
  }); 
  
  //Add interaction section
  await FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("messages")
      .doc(docRef.id)
      .collection("interactions")
      .add({
    "Name": "SocialOrb",
    "Sender": "SocialOrb",
    "Text": "Start the conversation",
    "Type": "text",
    "TimeStamp": FieldValue.serverTimestamp(),
  });
}
