import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> newFirebaseMessage(
    String churchID,
    String userID,
    String documentName,
    String type,
    String messageText,
    String sender,
    String receiverName,
    String receiverID,
    String image) async {

  //Create in the user's message document
  await FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('members')
      .doc(userID)
      .collection('messages')
      .doc(receiverName)
      .set({
        'Creator': userID,
        'Image': image,
        'Name': documentName,
        'Text': "Start the conversation.",
        'TimeStamp': FieldValue.serverTimestamp(),
        'Type': type,
      });

  //The first message of this document
  await FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('members')
      .doc(userID)
      .collection('messages')
      .doc(receiverName)
      .collection('interactions')
      .doc()
      .set({
        
        
        'Name': 'SocialOrb',
        'Text': "Start the conversation.",
        'TimeStamp': FieldValue.serverTimestamp(),
        'Type': type,
      });


      
}
