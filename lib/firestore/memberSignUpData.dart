import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String fname, String lname, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  String empty = "Empty";
  String status = "Member";
  String fullName = fname + lname;

  users.doc(uid).set({
    'ID': uid,
    'First Name': fname,
    'Last Name': lname,
    'Email Address': email,
    'About Me': empty,
    'Status': status,
    'ProfilePicName': empty,
    'ProfilePicUrl': empty,
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  users.doc(uid).collection('posts').doc().set({
    "First Name": fname,
    "Last Name": lname,
    "Status": 'Member',
    "Text": "Welcome to Social Circle! Start Engaging with your church by sharing your first post!",
    "Likes": {
      uid: 4288585374
    },
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}
