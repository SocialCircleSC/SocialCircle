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

  circle.doc(uid).set({
    //Maybe add church description?
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'Church ID': uid,
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  circle.doc(uid).collection('members').doc().set({
    "Email Address": email,
    "ID": "N/A",
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Church',
    "BirthdayD": 00,
    "BirthdayM": 00,
    "BirthdayY": 0000,
    'TimeStamp': FieldValue.serverTimestamp(),
    }
  );
  
  circle.doc(uid).collection('posts').doc().set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Status": 'Church',
    "Text": "Welcome to " + churchName + "'s Circle",
    "Likes": {
      uid: false
    },
    'TimeStamp': FieldValue.serverTimestamp(),
    }
  );

  // Upload to user collecetion

   typeUser.doc(uid).set({
    //Maybe add church description?
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'Church ID': uid,
    'TimeStamp': FieldValue.serverTimestamp(),
  });

}
