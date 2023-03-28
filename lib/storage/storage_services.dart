import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(var uid, String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('Users/Members/ProfilePicture/$uid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  //To create profile in Firebase storage
  Future<void> createStorageFile(var uid, String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('Users/Members/ProfilePicture/$uid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    for (var ref in results.items) {
      debugPrint('Found file: $ref');
    }
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadUrl = await storage.ref('test/$imageName').getDownloadURL();

    return downloadUrl;
  }
}
