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
    ChurchScreen(),
    GiveScreen(),
    ProfileScreen(),
  ];

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
          body: pageOptions[selectedPage],
          backgroundColor: Colors.white,
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
            title: const Text(
              'SocialCircle',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

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

          // ignore: prefer_const_literals_to_create_immutables
          bottomNavigationBar: GNav(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            gap: 8,
            backgroundColor: Color(0x00000000),
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
                icon: Icons.people,
                text: "Circle",
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
