import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String fname, String lname, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  String aboutMe = "Empty";
  String status = "Member";

  users.doc(uid).set({
    'First Name': fname,
    'Last Name': lname,
    'Email Address': email,
    'About Me': aboutMe,
    'Status': status,
  });
}
