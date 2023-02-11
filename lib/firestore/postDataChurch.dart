import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postDataChu(String postText, String status, String fName,
    String lName, String churchID) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  //Post Church Data
  CollectionReference postToMember = FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('posts');

  postToMember.add({
    'First Name': fName,
    'Last Name': lName,
    'ID': uid,
    'Text': postText,
    'Likes': 0,
    'Like Status': false,
    'Status': status,
    'TimeStamp': FieldValue.serverTimestamp(),
  });

}
