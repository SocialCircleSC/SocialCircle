import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
  String churchName,
  String address,
  String phoneN,
  String bibleVerse,
  String email,
) async {
  CollectionReference circle = FirebaseFirestore.instance.collection('circles');
  CollectionReference typeUser = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  var arr = [uid, false];

  circle.doc(uid).set({
    //Maybe add church description?
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'Hours': ["N/A", "N/A", "N/A", "N/A","N/A","N/A","N/A",],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Church ID': uid,
    'Pictures': ["https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a", "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a", "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a"],
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  circle.doc(uid).collection('members').doc().set({
    "Email Address": email,
    "ID": uid,
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Church',
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  circle.doc(uid).collection('posts').doc().set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Status": 'Church',
    "Text": "Welcome to " + churchName + "'s Circle",
    "LikedBy": [],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Picture': [],
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  // Upload to user collecetion

  typeUser.doc(uid).set({
    //Maybe add church description?
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'About': "",
    "ID": uid,
    'Church ID': uid,
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}
