import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socialorb/screens/navscreens/profile/editscreens/edit_user_profile.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? dropdownvalue;
  var items = [
    'Edit',
    'Delete',
  ];
  String currentID = "";
  String userID = "";
  String churchID = "";
  String firstName = "";
  String lastName = "";
  String status = "";
  String profilePic = "";
  String email = "";

  Future getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    String currID = uid.toString();
    String uID = "";
    String cID = "";
    String fName = "";
    String lName = "";
    String stat = "";
    String pPic = "";
    //String em = "";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      uID = value.get('ID');
      cID = value.get('Church ID');
      fName = value.get('First Name');
      lName = value.get('Last Name');
      pPic = value.get('ProfilePicture');
      //em = value.get('Email Address');
    });

    //Get Status
    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .collection('members')
        .get()
        .then((QuerySnapshot value) {
      for (var element in value.docs) {
        if (element["ID"] == uid) {
          stat = element["Status"];
        }
      }
    });

    setState(() {
      userID = uID;
      churchID = cID;
      firstName = fName;
      lastName = lName;
      profilePic = pPic;
      status = stat;
      currentID = currID;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? fcmToken;

  @override
  void initState() {
    super.initState();
    getFCMToken();  // Fetch the FCM token when the app starts
  }

    // Method to get the FCM token
  Future<void> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (for iOS)
    await requestNotificationPermissions();

    // Get the token
    String? token = await messaging.getToken();
    setState(() {
      fcmToken = token;
    });

    // Print or send the token to your backend server
    print("FCM Token: $fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    if (userID.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CircularProgressIndicator(),
        ],
      );
    }
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userID)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return ListView(
              children: [
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: WhiteColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    snapshot1.data!["ProfilePicture"]))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    snapshot1.data!["First Name"] +
                        " " +
                        snapshot1.data!["Last Name"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Center(
                  child: Text(
                    "Status: $status",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: SecondaryColor,
                    ),
                    child: const Text("Settings"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    firstName: snapshot1.data!['First Name'],
                                    lastName: snapshot1.data!['Last Name'],
                                    userID: snapshot1.data!['ID'],
                                    email: snapshot1.data!['Email Address'],
                                    profilePic:
                                        snapshot1.data!['ProfilePicture'],
                                    churchID: snapshot1.data!['Church ID'],
                                  )));
                      // if (userID == churchID) {
                      //   // Navigator.push(context,
                      //   // MaterialPageRoute(builder: (context) => EditChurchProfile(firstName: firstName, userID: userID, email: email, profilePic: profilePic))
                      //   // );
                      // } else {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => EditProfile(
                      //                 firstName: snapshot1.data['First Name'],
                      //                 lastName: snapshot1.data['Last Name'],
                      //                 userID: snapshot1.data['ID'],
                      //                 email: snapshot1.data['Email Address'],
                      //                 profilePic:
                      //                     snapshot1.data['ProfilePicture'],
                      //               )));
                      // }
                    },
                  ),

                  
                )),

                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: WhiteColor,
                      backgroundColor: SecondaryColor,
                    ),
                    child: const Text("Push Noti"),
                    onPressed: () {
                        // Example usage: Replace with actual device token
                        
                        sendPushNotification(fcmToken!, 'New Post Alert!', 'A user has made a new post in the app.', dotenv.env['PROJECT_ID']!, dotenv.env['SERVER_KEY']! );
                  
                    },
                  ),
              ],
            );
          }),
    );
  }

  getLikeCount(document) {
    int likeCount = 0;
    // ignore: prefer_typing_uninitialized_variables
    var exMap;
    exMap = document;
    likeCount = exMap.length;
    return likeCount.toString();
  }

  getLikeStatus(document, id) {
    // ignore: unused_local_variable
    List variable = document;
    if (document.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
  
  // Function to get OAuth2 token from GCP metadata server
Future<String?> getAccessToken() async {
  var url = Uri.parse(
      'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token');
  
  try {
    var response = await http.get(url, headers: {
      'Metadata-Flavor': 'Google',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      print('Error fetching access token: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

  //Curently Path is not working.
  Future<void> sendPushNotification(String fcmToken, String title, String body, String projectID, String serverKey) async {
  String? accessToken = await getAccessToken();

  if (accessToken == null) {
    print('Failed to get access token');
    return;
  }

  // Firebase Cloud Messaging HTTP v1 API URL
  String projectId = dotenv.env['PROJECT_ID']!;
  var url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

  // Device FCM token (replace with actual device token)
  String deviceToken = fcmToken;

  // Create the notification payload
  var notificationPayload = {
    "message": {
      "token": deviceToken,
      "notification": {
        "title": "New Post Alert!",
        "body": "Someone just posted on your social circle!"
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      }
    }
  };

  try {
    // Send the POST request with the OAuth2 token
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',  // Use OAuth2 access token
      },
      body: jsonEncode(notificationPayload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }

  }


Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission on iOS (optional on Android)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

}

