import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteComment(String postId, String churchID, String commentID) async {

  //Deletes on Firestore
  FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("posts")
      .doc(postId)
      .collection('comments')
      .doc(commentID)
      .delete();
}
