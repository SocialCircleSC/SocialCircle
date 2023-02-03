import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
  String churchName,
  String address,
  String phoneN,
  String bibleVerse,
  String email,
) async {
  CollectionReference users = FirebaseFirestore.instance.collection('circles');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  users.doc(uid).set({
    //Maybe add church description?
    'Name': churchName,
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Church ID': uid,
  });

  users.doc(uid).collection('members').doc().set({
    "Email Address": email,
    "ID": "N/A",
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Member',
    "BirthdayD": 00,
    "BirthdayM": 00,
    "BirthdayY": 0000,
    }
  );
  
  users.doc(uid).collection('posts').doc().set({
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Church',
    "Text": "Welcome to " + churchName + "'s Circle",
    "Likes": 0,
    "Like Status": false,
    }
  );
}
