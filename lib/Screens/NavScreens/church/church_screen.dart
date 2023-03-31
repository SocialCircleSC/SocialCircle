import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../homescreen/bigger_picture.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({Key? key}) : super(key: key);

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  //getChurchInfo
  String churchID = "";
  String userID = "";

  Future getCurrentChurch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var cID;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
    });

    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .get()
        .then((value) {
      cID = value.get('Church ID');
    });

    setState(() {
      churchID = cID;
      userID = uid.toString();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting ||
                snapshot1.connectionState == ConnectionState.none) {
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
                CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      height: 300,
                    ),
                    items: snapshot1.data['Pictures'].map<Widget>(((e) {
                      return Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BiggerPicture(picture: e)));
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  e,
                                  width: displayWidth(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              AnimatedSmoothIndicator(
                                activeIndex: snapshot1.data["Pictures"]
                                    .indexWhere((f) => f == e),
                                count: snapshot1.data['Pictures'].length,
                              ),
                            ],
                          ),
                        );
                      });
                    })).toList()),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    snapshot1.data["First Name"] +
                        " " +
                        snapshot1.data["Last Name"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Center(
                  child: Text(
                    "Status: " + snapshot1.data["Status"],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: WhiteColor,
                        backgroundColor: SecondaryColor,
                      ),
                      child: const Text("Hours"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  children: [
                                    const Text("Weekly Events",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                        "Sunday: " + snapshot1.data["Hours"][0],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Monday: " +
                                        snapshot1.data["Hours"][1]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Tuesday: " +
                                        snapshot1.data["Hours"][2]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Wednesday: " +
                                        snapshot1.data["Hours"][3]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Thrusday: " +
                                        snapshot1.data["Hours"][4]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Friday: " +
                                        snapshot1.data["Hours"][5]),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Saturday: " +
                                        snapshot1.data["Hours"][6]),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: WhiteColor,
                        backgroundColor: SecondaryColor,
                      ),
                      child: const Text("Members"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  children: [
                                    // ListView(
                                    //   children: ,
                                    // )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (userID == churchID)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: WhiteColor,
                          backgroundColor: SecondaryColor,
                        ),
                        child: const Text("Edit"),
                        onPressed: () {},
                      ),
                  ],
                )
              ],
            );
          }),
    );
  }
}
