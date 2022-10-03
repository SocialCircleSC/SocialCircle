import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postDataChu(String postText, String status, String cName) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;


  //Post Church Data
  CollectionReference postToMember = FirebaseFirestore.instance
      .collection('Churches')
      .doc(uid)
      .collection('Posts');

  postToMember.doc().set({
    'Name': cName,
    'Post Text': postText,
    'ID': uid,
    'Likes': 0,
    'Status': status,
  });
}
