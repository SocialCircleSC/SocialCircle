// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/messaging/message_home.dart';
import 'package:community/screens/navscreens/church/church_screen.dart';
import 'package:community/screens/navscreens/give/give_screen.dart';
import 'package:community/screens/navscreens/homescreen/home_screen.dart';
import 'package:community/screens/navscreens/homescreen/post_screen.dart';
import 'package:community/screens/navscreens/profile/profile_screen/profile_screen.dart';
import 'package:community/main.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  dynamic selected;
  PageController controller = PageController();
  TextEditingController groupController = TextEditingController();
  String churchID = "";
  String userID = "";

  Future getUserAndChurchInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    // ignore: prefer_typing_uninitialized_variables
    var cID;

    //Get ChurchID
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
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
    getUserAndChurchInfo();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          extendBody: true, // To make floating action button notch transparent
          body: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              ChurchScreen(),
              GiveScreen(),
              ProfileScreen(),
            ],
          ),
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.lightbulb,
                    color: BlackColor,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MessageHome()));
                  },
                  icon: Icon(
                    Icons.message_rounded,
                    color: BlackColor,
                  )),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: BlackColor),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            //This should be the logo not text
            title: Text(
              "SocialOrb",
              style: TextStyle(color: BlackColor),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),

          bottomNavigationBar: StylishBottomBar(
              items: [
                BottomBarItem(
                  icon: const Icon(Icons.house_outlined),
                  title: const Text('Home'),
                  selectedIcon: const Icon(Icons.house_rounded),
                  selectedColor: PrimaryColor,
                  backgroundColor: BlackColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.circle_outlined),
                  title: const Text('Orb'),
                  selectedIcon: const Icon(Icons.circle_rounded),
                  selectedColor: PrimaryColor,
                  backgroundColor: BlackColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.monetization_on_outlined),
                  title: const Text('Give'),
                  selectedIcon: const Icon(Icons.monetization_on_rounded),
                  selectedColor: PrimaryColor,
                  backgroundColor: BlackColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.person_outlined),
                  title: const Text('Profile'),
                  selectedIcon: const Icon(Icons.person_rounded),
                  selectedColor: PrimaryColor,
                  backgroundColor: BlackColor,
                ),
              ],
              hasNotch: true,
              fabLocation: StylishBarFabLocation.center,
              currentIndex: selected ?? 0,
              onTap: (index) {
                setState(() {
                  selected = index;
                  controller.jumpToPage(index);
                });
              },
              option: AnimatedBarOptions(
                  barAnimation: BarAnimation.liquid,
                  iconStyle: IconStyle.animated)),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostScreen()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: PrimaryColor,
            foregroundColor: WhiteColor,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()));
    Fluttertoast.showToast(msg: "Logout Successful");
  }
}
