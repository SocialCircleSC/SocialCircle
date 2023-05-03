import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String fname, String lname, String email, String churchName, String churchID) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  
  String status = "Visitor";

  users.doc(uid).set({
    'ID': uid,
    'First Name': fname,
    'Last Name': lname,
    'Email Address': email,
    'Status': status,
    'Church Name': churchName,
    'Church ID': "TBD",
    'ProfilePicture': "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
  });


}
