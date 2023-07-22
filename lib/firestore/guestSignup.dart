// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> guestSetup(String fname, String lname, String email,) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  
  String status = "Visitor";

  users.doc(uid).set({
    'ID': "guest",
    'First Name': fname,
    'Last Name': lname,
    'Email Address': email,
    'Status': status,
    'Church Name': "Discover",
    'Church ID': "7PEVPi7V6VU7fMsXCA5X0m8crxj2",
    'ProfilePicture': "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}



