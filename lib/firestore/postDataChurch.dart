import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> postDataChu(String postText, String status, String fName,
    String lName, String churchID, String userID) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  var arr = [userID, false];

  await FirebaseFirestore.instance
      .collection('circles')
      .doc(churchID)
      .collection('posts')
      .add({
        'First Name': fName,
        'Last Name': lName,
        'ID': uid,
        'Text': postText,
        'Status': status,
        'Likes': {
          userID: false
        },
        'TimeStamp': FieldValue.serverTimestamp(),
  });

}
