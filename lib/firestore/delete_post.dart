import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deletePost(String id, String churchID, List picList) async {
  //Delete from firestoreage
  if (picList.isNotEmpty) {
    for (int i = 0; i < picList.length; i++) {
      await FirebaseStorage.instance.refFromURL(picList[i]).delete();
    }
  }

  //Deletes on Firestore
  FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("posts")
      .doc(id)
      .delete();
}
