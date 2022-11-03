import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(var uid, String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('Users/Members/ProfilePicture/$uid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  //To create profile in Firebase storage
  Future<void> createStorageFile(var uid, String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('Users/Members/ProfilePicture/$uid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadUrl = await storage.ref('test/$imageName').getDownloadURL();

    return downloadUrl;
  }
}
