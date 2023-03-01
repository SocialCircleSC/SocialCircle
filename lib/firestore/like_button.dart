import 'package:cloud_firestore/cloud_firestore.dart';

//Get the number of likes, and update like status
Future<void> onFavButtonTapped(
    String userID, String churchID, String likePost) async {
  //If the the post has already been liked, remove user from the array Else add user to the array
  FirebaseFirestore.instance
      .collection("circles")
      .doc(churchID)
      .collection("posts")
      .doc(likePost)
      .get()
      .then((value) {
    if (value['Likes'].contains(userID)) {
      //Do Nothing
    } else {
      //Add to the array
      FieldValue.arrayUnion([userID, false]);
    }
  });
}
