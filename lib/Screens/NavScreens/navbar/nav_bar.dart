// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:community/screens/navscreens/church/church_screen.dart';
import 'package:community/screens/navscreens/give/give_screen.dart';
import 'package:community/screens/navscreens/groups/group_screen.dart';
import 'package:community/screens/navscreens/homescreen/home_screen.dart';
import 'package:community/screens/navscreens/homescreen/post_screen.dart';
import 'package:community/screens/navscreens/profile/profile_screen/profile_screen.dart';
import 'package:community/main.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
                  selectedColor: SecondaryColor,
                  backgroundColor: PrimaryColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.church_outlined),
                  title: const Text('Church'),
                  selectedIcon: const Icon(Icons.church_rounded),
                  selectedColor: SecondaryColor,
                  backgroundColor: PrimaryColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.monetization_on_outlined),
                  title: const Text('Give'),
                  selectedIcon: const Icon(Icons.monetization_on_rounded),
                  selectedColor: SecondaryColor,
                  backgroundColor: PrimaryColor,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.person_outlined),
                  title: const Text('Profile'),
                  selectedIcon: const Icon(Icons.person_rounded),
                  selectedColor: SecondaryColor,
                  backgroundColor: PrimaryColor,
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
