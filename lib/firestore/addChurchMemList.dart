// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Place user into church member list
Future addChurchMemberList(
    String churchIDENTITY, String email, String fname, String lname) async {
  CollectionReference circle = FirebaseFirestore.instance.collection('circles');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  String removeParenthese(String data) {
    return data.substring(1, data.length - 1);
  }

  circle
      .doc(removeParenthese(churchIDENTITY))
      .collection('members')
      .doc(uid.toString())
      .set({
    'Email Address': email,
    'ID': uid.toString(),
    'First Name': fname,
    'Last Name': lname,
    'Status': "Visitor",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  circle
      .doc(removeParenthese(churchIDENTITY))
      .collection('members')
      .doc(uid.toString())
      .collection("messages")
      .doc("Welcome")
      .set({
    'Name': "Welcome",
    'Image': "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
      });

    circle
      .doc(removeParenthese(churchIDENTITY))
      .collection('members')
      .doc(uid.toString())
      .collection("messages")
      .doc("Welcome")
      .collection("interactions")
      .doc()
      .set({
    'Name': "SocialOrb",
    'Text': "Welcome to SocialOrb Messaging Center! This is just a Welcome message. Any messages sent will not be replied to",
    'TimeStamp': FieldValue.serverTimestamp(),
      });
}
