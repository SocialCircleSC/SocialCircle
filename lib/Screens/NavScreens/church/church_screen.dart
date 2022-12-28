import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({Key? key}) : super(key: key);

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  var userChurchID;
  var finalString = "Empty";
  List<Map<String, dynamic>> currentChurch = [];

  Future getUserInfo() async {
    String userID = "";

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      userID = value.get("Church ID");
    });

    setState(() {
      userChurchID = userID;
    });
  }

  String removeParenthese(String data) {
    return data.substring(1, data.length - 1);
  }

  Future getCurrentChurch() async {
    List<Map<String, dynamic>> churchData = [];
    var simpleString = "Empty";

    var datas = await FirebaseFirestore.instance
        .collection('Churches')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.id.toString() == userChurchID) {
          //simpleString = doc['Church Name'].toString();
          churchData.add({'Current Church': doc['Church Name']});
          churchData.add({'Street Address': doc['Street Address']});
          churchData.add({'Bible Verse': doc['Bible Verse']});
          break;
        }
      }
    });

    setState(() {
      currentChurch = churchData;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
    getCurrentChurch();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: Future.wait([
              getUserInfo(),
              getCurrentChurch(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('lib/assets/churchImage.jpg'),
                      height: displayHeight(context) * 0.25,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: semiLeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          removeParenthese(currentChurch[0].values.toString()),
                          style: const TextStyle(
                            color: BlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: semiLeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          removeParenthese(currentChurch[1].values.toString()),
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: semiLeftPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          removeParenthese(currentChurch[2].values.toString()),
                          style: const TextStyle(
                            color: BlackColor,
                            fontSize: 15,
                            fontFamily: '',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: semiLeftPadding,
                      child: RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'See Hours                   ',
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'See Members',
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    const Divider(
                      color: BlackColor,
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.01,
                    ),
                    const Text(
                      "Posts and Replies",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
  }
}
