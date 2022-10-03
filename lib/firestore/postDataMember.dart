import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postDataMem(String postText, String status, String fName, String lName, String churchID) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  //Post Member Data
  CollectionReference postToUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Posts');

  postToUser.doc().set({
    'Name': fName + " " + lName,
    'Post Text': postText,
    'ID': uid,
    'Likes': 0,
    'Status': status,
  });

    //Post Church Data
  CollectionReference postToChurch = FirebaseFirestore.instance
      .collection('Churches')
      .doc(churchID)
      .collection('Posts');

  postToChurch.doc().set({
    'Name': fName + " " + lName,
    "Share Status": "Not Shared",
    'Post Text': postText,
    'ID': uid,
    'Likes': 0,
    'Status': status,
  });
}
