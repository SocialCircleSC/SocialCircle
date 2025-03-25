// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> churchSetup(
  String churchName,
  String address,
  String phoneN,
  String email,
  String event1,
  String stripeAccountID, {
  String subscriptionPlan = 'free',
  int maxMembers = 50,
  String? customerId,
  String? customerPortalUrl,
}) async {
  CollectionReference circle = FirebaseFirestore.instance.collection('circles');
  CollectionReference typeUser = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;

  await circle.doc(uid).set({
    "First Name": churchName,
    "Last Name": ' ',
    'Street Address': address,
    'Phone Number': phoneN,
    'Email Address': email,
    'Status': 'Church',
    'Stripe Connected ID': stripeAccountID,
    
    // Subscription data
    'Subscription Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Subscription Date': FieldValue.serverTimestamp(),
    'Stripe Customer ID': customerId,
    'Customer Portal URL': customerPortalUrl,

    'Number of Members': 0,
    'Church ID': uid,
    'Events': [event1],
    'ListStatus': [
      "Visitor",
      "Member",
      "Pastor",
      "Assistant Pastor",
      "Choir",
      "Usher"
    ],
    'Pictures': [
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
      "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a"
    ],
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For Members
  await circle.doc(uid).collection('members').doc(uid).set({
    "Email Address": email,
    "ID": uid,
    "First Name": churchName,
    "Last Name": ' ',
    "Status": 'Church',
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For messages
  await circle.doc(uid).collection("messages").doc("Welcome").set({
    "Title": "Welcome!",
    'Image':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
    'Creator': uid,
    'Text':
        "Welcome to SocialOrb Messaging Center! This is just a Welcome message. Any messages sent will not be replied to",
    'Members': FieldValue.arrayUnion([uid]),
  });
  
  //For Giving
  await circle.doc(uid).collection("giving").doc().set({
    "Giver": uid,
    'Amount': 0,
    'Date': FieldValue.serverTimestamp(),
  });

  //For interactions
  await circle
      .doc(uid)
      .collection("messages")
      .doc("Welcome")
      .collection("interactions")
      .doc()
      .set({
    'Name': "SocialOrb",
    'Sender': "SocialOrb",
    'Text':
        "Welcome to SocialOrb Messaging Center! This is just a Welcome message. Any messages sent will not be replied to",
    'Type': 'text',
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For posts
  await circle.doc(uid).collection('posts').doc('welcomePost').set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Church ID": uid,
    "Status": 'Church',
    "Text": "Welcome to $churchName's Orb!",
    "LikedBy": [],
    'Picture': [],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  //For comments
  await circle
      .doc(uid)
      .collection('posts')
      .doc('welcomePost')
      .collection("comments")
      .doc()
      .set({
    "First Name": churchName,
    "Last Name": ' ',
    "ID": uid,
    "Church ID": uid,
    "Status": 'Church',
    "Text": "Write a comment!",
    "LikedBy": [],
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'Type': "Text",
    'TimeStamp': FieldValue.serverTimestamp(),
  });

  // Upload to user collection
  await typeUser.doc(uid).set({
    "First Name": churchName,
    "Last Name": ' ',
    'Church Name': churchName,
    'Email Address': email,
    'Status': 'Church',
    "GiveUrl": "",
    "ID": uid,
    'Church ID': uid,
    
    // Add subscription data
    'Subscription Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Subscription Date': FieldValue.serverTimestamp(),
    'Stripe Customer ID': customerId,
    'Customer Portal URL': customerPortalUrl,
    
    'ProfilePicture':
        "https://firebasestorage.googleapis.com/v0/b/socialcircle-4f104.appspot.com/o/Everybody%2F1680057089423811?alt=media&token=87a625f7-6ef0-41c3-bc17-3c01279c089a",
    'TimeStamp': FieldValue.serverTimestamp(),
  });
  
  // Create a separate subscription tracking document
  await FirebaseFirestore.instance.collection('subscriptions').doc(uid).set({
    'Church ID': uid,
    'Church Name': churchName,
    'Email': email,
    'Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Start Date': FieldValue.serverTimestamp(),
    'Status': 'active',
    'Stripe Connected ID': stripeAccountID,
    'Stripe Customer ID': customerId,
    'Customer Portal URL': customerPortalUrl,
  });
}

// A dedicated function to update subscription details
Future<void> updateChurchSubscription(
  String churchId,
  String subscriptionPlan,
  int maxMembers, {
  String? customerId,
  String? customerPortalUrl,
}) async {
  CollectionReference circles = FirebaseFirestore.instance.collection('circles');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference subscriptions = FirebaseFirestore.instance.collection('subscriptions');
  
  // Update subscription in circles collection
  await circles.doc(churchId).update({
    'Subscription Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Subscription Date': FieldValue.serverTimestamp(),
    if (customerId != null) 'Stripe Customer ID': customerId,
    if (customerPortalUrl != null) 'Customer Portal URL': customerPortalUrl,
  });
  
  // Update subscription in users collection
  await users.doc(churchId).update({
    'Subscription Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Subscription Date': FieldValue.serverTimestamp(),
    if (customerId != null) 'Stripe Customer ID': customerId,
    if (customerPortalUrl != null) 'Customer Portal URL': customerPortalUrl,
  });
  
  // Update subscription tracking document
  await subscriptions.doc(churchId).update({
    'Plan': subscriptionPlan,
    'Max Members': maxMembers,
    'Update Date': FieldValue.serverTimestamp(),
    if (customerId != null) 'Stripe Customer ID': customerId,
    if (customerPortalUrl != null) 'Customer Portal URL': customerPortalUrl,
  });
}

// Function to check if a church has reached its member limit
Future<bool> checkMemberLimit(String churchId) async {
  try {
    // Get church document
    DocumentSnapshot churchDoc = await FirebaseFirestore.instance
        .collection('circles')
        .doc(churchId)
        .get();
    
    if (!churchDoc.exists) {
      return false;
    }
    
    Map<String, dynamic> data = churchDoc.data() as Map<String, dynamic>;
    
    int currentMembers = data['Number of Members'] ?? 0;
    int maxMembers = data['Max Members'] ?? 50;
    
    // Return true if limit reached
    return currentMembers >= maxMembers;
  } catch (e) {
    print("Error checking member limit: $e");
    // Default to false to allow member addition in case of error
    return false;
  }
}