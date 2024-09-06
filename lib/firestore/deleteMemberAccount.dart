import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialorb/firestore/getChurchID.dart';

Future<void> deleteMember(String userID, String churchID) async {

  debugPrint("1");
  //Delete from users
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .delete();

    debugPrint("2");
  //This isnt working for some reason
  //Delete from church
  // debugPrint(churchID);
  // await FirebaseFirestore.instance
  //   .collection("circles")
  //   .doc(churchID)
  //   .collection("members")
  //   .doc('userID')
  //   .delete();

  //   debugPrint("3");
}





