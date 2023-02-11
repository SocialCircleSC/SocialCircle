import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deletePost(String id, String churchID) async {
  //Deletes on the church side
  FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("posts")
      .doc(id)
      .delete();

  //Delete on the member side
}
