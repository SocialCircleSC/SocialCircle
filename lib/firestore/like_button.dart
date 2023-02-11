import 'package:cloud_firestore/cloud_firestore.dart';

  
  
  Future<void> onFavButtonTapped(
      String id, int numLikes, bool likeStatus, String churchID) async {
    // if isLiked = true, then add 1 to the likes
    // if isLiked = false, then substract 1 from the likes
    if (likeStatus == false) {
      FirebaseFirestore.instance
          .collection("circles")
          .doc(churchID)
          .collection("posts")
          .doc(id) //get the document ID
          .update(
              {'Likes': numLikes + 1, 'Like Status': true}) // <-- Updated data
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      FirebaseFirestore.instance
          .collection("circles")
          .doc(churchID)
          .collection("posts")
          .doc(id) //get the document ID
          .update(
              {'Likes': numLikes - 1, 'Like Status': false}) // <-- Updated data
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
  }