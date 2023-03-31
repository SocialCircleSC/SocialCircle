import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postComment(
    String postText,
    String status,
    String fName,
    String lName,
    String churchID,
    String userID,
    String postID,
    String profilePic) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  await FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('posts')
      .doc(postID)
      .collection('comments')
      .add({
    'First Name': fName,
    'Last Name': lName,
    'ID': uid,
    'Text': postText,
    'Status': status,
    'LikedBy': [],
    'Type': "Text",
    'ProfilePicture': profilePic,
    'TimeStamp': FieldValue.serverTimestamp(),
  });
}
