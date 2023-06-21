// ignore_for_file: unused_local_variable, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updatePost(String churchID, String postText, String docID) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  //Post Church Data
  CollectionReference postToCircle = FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('posts');

  postToCircle.doc(docID).update({
    'Text': postText,
  });

}
