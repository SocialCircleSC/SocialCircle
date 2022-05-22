import 'package:community/Screens/NavScreens/DiscussScreen.dart';
import 'package:community/Screens/NavScreens/GiveScreen.dart';
import 'package:community/Screens/HomeScreen/HomeScreen.dart';
import 'package:community/Screens/NavScreens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedPage = 0;

  final pageOptions = [
    HomeScreen(),
    DiscussScreen(),
    GiveScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pageOptions[selectedPage],
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'SocialCircle',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        // ignore: prefer_const_literals_to_create_immutables
        bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: Colors.white70,
          color: Colors.black,
          activeColor: Colors.black,
          onTabChange: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.church,
              text: "Church",
            ),
            GButton(
              icon: Icons.monetization_on_rounded,
              text: "Give",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }
}
