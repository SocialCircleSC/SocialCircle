// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:community/screens/authscreens/login/login_screen.dart';
import 'package:community/screens/navscreens/homescreen/home_screen.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/screens/navscreens/profile/editscreens/edit_profile_picture.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/sizes/size.dart';

class ChooseChurch extends StatefulWidget {
  const ChooseChurch({Key? key}) : super(key: key);

  @override
  State<ChooseChurch> createState() => _ChooseChurchState();
}

class _ChooseChurchState extends State<ChooseChurch> {
  String searchString = "";

  List<Map<String, dynamic>> allChurches = [];
  List<Map<String, dynamic>> allChurches2 = [];
  List<Map<String, dynamic>> churchAddress = [];
  List<Map<String, dynamic>> churchID = [];

  //Global variables for the user's info.
  var cID = " ";
  var mEmail = " ";
  var mFName = " ";
  var mLName = " ";
  var mID = " ";
  var mStatus = " ";

  Future getMemberInfo() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var churchIDEN = " ";
    var email = " ";
    var fName = " ";
    var lName = " ";
    var memberID = " ";
    var status = " ";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      churchIDEN = value.data()!['Church ID'];
      email = value.data()!["Email Address"];
      fName = value.data()!["First Name"];
      lName = value.data()!["Last Name"];
      memberID = value.data()!["ID"];
      status = value.data()!["Status"];
    });

    setState(() {
      cID = churchIDEN;
      mEmail = email;
      mFName = fName;
      mLName = lName;
      mID = memberID;
      mStatus = status;
    });

  }

  // This list holds the data for the list view
  List<Map<String, dynamic>> foundChurches = [];

  String removeParenthese(String data) {
    return data.substring(1, data.length - 1);
  }

  Future<void> addChurchData(String churchName, String church) {
    // Call the user's CollectionReference to add a new user

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    return users.doc(uid).update({
      'Church Name': removeParenthese(churchName),
      'Church ID': removeParenthese(church)
    }).catchError((error) => debugPrint("Failed to add chruch: $error"));
  }

  //Place user into church member list
  Future addChurchMemberList(String churchIDENTITY, String email, String fname,
      String lname, String memID, String status) async {
    CollectionReference circle =
        FirebaseFirestore.instance.collection('circles');
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;


    debugPrint("HI HI HUDB FHFH HJFHFD HJFJSSH FHDFKJFD HFKFDUFHBFDH");
    debugPrint(churchIDENTITY);
    circle.doc(removeParenthese(churchIDENTITY)).collection('members').add({
      'Email Address': email,
      'User ID': memID,
      'First Name': fname,
      'Last Name': lname,
      'Status': status,
    }).catchError((error) => debugPrint(e.toString()));
  }

  Future getChurchList() async {
    List<Map<String, dynamic>> answer = [];
    List<Map<String, dynamic>> answerId = [];
    List<Map<String, dynamic>> answerAddress = [];

    var data = await FirebaseFirestore.instance
        .collection('circles')
        .orderBy('First Name', descending: true)
        .get()
        .then((value) {
      for (var i in value.docs) {
        answer.add({"name": i.get('First Name')});
        answerAddress.add({"name": i.get('Street Address')});
        answerId.add({"docID": i.id});
      }
    });

    setState(() {
      allChurches = answer;
      allChurches2 = answer;
      churchAddress = answerAddress;
      churchID = answerId;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchList();
    getMemberInfo();
  }

  @override
  initState() {
    // at the beginning, all users are shown
    foundChurches = allChurches;
    super.initState();
  }

  void filterChurches(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allChurches2;
    } else {
      results = allChurches
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      allChurches = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Almost There!',
            style: TextStyle(color: WhiteColor),
          ),
          leading: IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: WhiteColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              TextField(
                onChanged: (value) => filterChurches(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              SizedBox(
                height: displayHeight(context) * 0.01,
              ),
              Expanded(
                child: allChurches.isNotEmpty //Found Churches
                    ? ListView.builder(
                        itemCount: allChurches.length, //FoundChurches
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(allChurches[index].values.toString()),
                            subtitle: Text(
                                '${churchAddress[index].values.toString()} '),
                            onTap: () {
                              addChurchData(
                                  allChurches[index].values.toString(),
                                  churchID[index].values.toString());
                              addChurchMemberList(
                                  churchID[0].values.toString(), mEmail, mFName, mLName, mID, mStatus);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavBar()));
                            },
                          ),
                        ),
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
