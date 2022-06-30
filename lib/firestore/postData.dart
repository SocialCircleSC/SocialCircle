import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postData(String postText, String status) async {
  var type;
  if (status == 'Member') {
    type = 'Users';
  } else {
    type = 'Churches';
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  CollectionReference post = FirebaseFirestore.instance
      .collection(type)
      .doc(uid)
      .collection('Posts');

  post.doc().set({
    'Post Text': postText,
    'ID': uid,
    'Likes': 0,
    'Status': status,
  });
}
