import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final QuerySnapshot snapshot;

  PostModel(this.snapshot);
}
