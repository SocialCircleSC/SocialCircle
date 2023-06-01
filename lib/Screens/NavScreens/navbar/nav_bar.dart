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

import '../../../sizes/size.dart';

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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => messageHome()));
                  },
                  icon: Icon(
                    Icons.message_rounded,
                    color: BlackColor,
                  )),
              IconButton(
                  onPressed: () {
                    //Show Groups
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              Text(
                                "Change Page",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (userID == churchID)
                                TextField(
                                  controller: groupController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    hintText: "Add New Group",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: PrimaryColor),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: PrimaryColor),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: PrimaryColor),
                                    ),
                                  ),
                                ),
                              if (userID == churchID)
                                ElevatedButton(
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: groupController.text +
                                            " has been added",
                                        toastLength: Toast.LENGTH_SHORT);
                                    setState(() {
                                      groupController.text = "";
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Add"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: PrimaryColor,
                                      foregroundColor: WhiteColor),
                                ),
                            ],
                          ),
                          content: SizedBox(
                            height: 200,
                            width: 400,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index2) {
                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight:
                                            displayHeight(context) * 0.07,
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text("Choir"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 10,
                                    thickness: 0.5,
                                  );
                                },
                                itemCount: 1),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Done"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.group,
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
