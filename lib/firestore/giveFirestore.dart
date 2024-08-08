import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> giveFirestore(int amount) async {

  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  var cID;

  //Get Church ID
  await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get()
    .then((value) {
      cID = value.get('Church ID');
  });

  await FirebaseFirestore.instance
      .collection("circles")
      .doc(cID)
      .collection("giving")
      .doc().set({
        "Giver": uid,
        'Amount': amount,
        'Date': FieldValue.serverTimestamp(),
      });


}