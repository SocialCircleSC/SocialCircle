// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:community/screens/authscreens/login/login_screen.dart';
import 'package:community/screens/authscreens/signup/guest_signup.dart';
import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/sizes/size.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../firestore/addChurchMemList.dart';
import '../../firestore/guestSignup.dart';
import '../../firestore/memberSignUpData.dart';

class ChooseChurch extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool guest;

  const ChooseChurch(
      {Key? key,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.guest})
      : super(key: key);

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

  var mID = "";
  var mStatus = "Visitor";

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

  Future getChurchList() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    // ignore: prefer_typing_uninitialized_variables
    var memberID;
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
      mID = uid.toString();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchList();
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
                            onTap: () async {
                              //This is where the signup is
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text(
                                          "Are you sure you want to pick " +
                                              allChurches[index]
                                                  .values
                                                  .toString() +
                                              " as your church?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            try {
                                              UserCredential userCredential =
                                                  await FirebaseAuth.instance
                                                      .createUserWithEmailAndPassword(
                                                          email: widget.email,
                                                          password:
                                                              widget.password);

                                              userSetup(
                                                  widget.firstName,
                                                  widget.lastName,
                                                  widget.email,
                                                  allChurches[index]
                                                      .values
                                                      .toString(),
                                                  churchID[index]
                                                      .values
                                                      .toString());
                                              addChurchData(
                                                  allChurches[index]
                                                      .values
                                                      .toString(),
                                                  churchID[index]
                                                      .values
                                                      .toString());
                                              addChurchMemberList(
                                                  churchID[index]
                                                      .values
                                                      .toString(),
                                                  widget.email,
                                                  widget.firstName,
                                                  widget.lastName);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()));
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Your acocunt has been created. Please Login to use the app",
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "The Password is too weak, please go back and change the password",
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              } else if (e.code ==
                                                  'email-already-in-use') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Email already exists, please go back and change the email",
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
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
