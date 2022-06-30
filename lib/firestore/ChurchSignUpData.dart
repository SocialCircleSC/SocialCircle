import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
    String churchName,
    String address,
    String phoneN,
    String bibleVerse,
    String email,
    String wS1,
    String wS2,
    String wS3,
    String wS4,
    String wS5) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Churches');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  String empty = "empty";

  if (wS2.isEmpty) {
    wS2 = empty;
  }

  if (wS3.isEmpty) {
    wS3 = empty;
  }
  if (wS4.isEmpty) {
    wS4 = empty;
  }

  if (wS5.isEmpty) {
    wS5 = empty;
  }

  users.doc(uid).set({
    'Church Name': churchName,
    'Street Address': address,
    'phoneN': phoneN,
    'Bible Verse': bibleVerse,
    'Email Address': email,
    'Weekly Service 1': wS1,
    'Weekly Service 2': wS2,
    'Weekly Service 3': wS3,
    'Weekly Service 4': wS4,
    'Weekly Service 5': wS5,
  });
}
