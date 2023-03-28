
// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateProfile(
    String fName, String lName, String email, String aboutMe) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  users.doc(uid).update({
    'First Name': fName,
    'Last Name': lName,
    'Email Address': email,
    'About Me': aboutMe,
    });
}
