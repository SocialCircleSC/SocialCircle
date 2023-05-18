import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
  String churchName,
  String address,
  String phoneN,
  String email,
  String event1,
) async {
  CollectionReference circle = FirebaseFirestore.instance.collection('circles');
  CollectionReference typeUser = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  circle.doc(uid).set({
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'Church ID': uid,
    'Events': [event1],
    'ListStatus': [
      "Visitor",
      "Member",
      "Pastor",
      "Assistant Pastor",
      "Choir",
      "Usher"
    ],
    'Pictures': [
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a"
    ],
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For Members
  circle.doc(uid).collection('members').doc(uid).set({
    "Email Address": email,
    "ID": uid,
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Church',
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For messages
  circle
      .doc(uid)
      .collection('members')
      .doc(uid)
      .collection("messages")
      .doc()
      .set({
    "Title": "Welcome!",
    'Image':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
    'Creator': uid,
    'Text': "Welcome to SocialOrb Messaging Center! This is just a Welcome message. Any messages sent will not be replied to",
    'Members': FieldValue.arrayUnion(uid as List),

    
  });

  //For interactions
  circle
      .doc(uid)
      .collection('members')
      .doc(uid)
      .collection("messages")
      .doc("Welcome")
      .collection("interactions")
      .doc()
      .set({
    'Name': "SocialOrb",
    'Sender': "SocialOrb",
    'Text':
        "Welcome to SocialOrb Messaging Center! This is just a Welcome message. Any messages sent will not be replied to",
    'Type': 'text',
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For posts
  circle.doc(uid).collection('posts').doc('welcomePost').set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Church ID": uid,
    "Status": 'Church',
    "Text": "Welcome to " + churchName + "'s Orb!",
    "LikedBy": [],
    'Picture': [],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For comments
  circle
      .doc(uid)
      .collection('posts')
      .doc('welcomePost')
      .collection("comments")
      .doc()
      .set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Church ID": uid,
    "Status": 'Church',
    "Text": "Write a comment!",
    "LikedBy": [],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  // Upload to user collecetion
  typeUser.doc(uid).set({
    //Maybe add church description?
    "First Name": churchName,
    "Last Name": ' ',
    'Church Name': churchName,
    'Email Address': email,
    'Status': 'Church',
    "ID": uid,
    'Church ID': uid,
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}
