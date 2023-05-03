import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
  String churchName,
  String address,
  String phoneN,
  String email,
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
    'Pictures': ["https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a", "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a", "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a"],
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
  circle.doc(uid).collection('members').doc(uid).collection("messages").doc(uid).set({
    "Name": "Welcome!",
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
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });


  //For comments
  circle.doc(uid).collection('posts').doc('welcomePost').collection("comments").doc().set({
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
