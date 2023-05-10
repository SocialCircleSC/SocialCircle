import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendMessage(String churchID, String userID, String documentID,
    String type, String messageText, bool isSentByMe, String name) async {
  if (type == "text") {
    //Add to messages section
    await FirebaseFirestore.instance
        .collection("circles")
        .doc(churchID)
        .collection("members")
        .doc(userID)
        .collection("messages")
        .doc(documentID)
        .update({
      "Type": type,
      "Text": messageText,
      "TimeStamp": FieldValue.serverTimestamp(),
    });

    //Add to interactions section
    await FirebaseFirestore.instance
        .collection("circles")
        .doc(churchID)
        .collection("members")
        .doc(userID)
        .collection("messages")
        .doc(documentID)
        .collection("interactions")
        .add({
      "Name": name,
      "Type": type,
      "Text": messageText,
      "TimeStamp": FieldValue.serverTimestamp(),
      "isSentByMe": isSentByMe,
    });
  } else {}
}
