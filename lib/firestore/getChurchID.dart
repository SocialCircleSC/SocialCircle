import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> getCID(String uID) async{
  String ID = "";


  //Get ChurchID
  FirebaseFirestore.instance
      .collection("users")
      .doc(uID)
      .get()
      .then((value) => {
        ID = value['Church ID']
      });

  return ID;


}