import 'package:community/screens/navscreens/navbar/nav_bar.dart';
import 'package:community/sizes/size.dart';
import 'package:flutter/material.dart';
import 'package:community/themes/theme.dart';

class BiggerPicture extends StatelessWidget {
  final String picture;
  const BiggerPicture({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: const Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //title: const Text('Post to Church', style: TextStyle(color: PrimaryColor),),
          leading: IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: WhiteColor,
            ),
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                picture,
                height: displayHeight(context) * 0.9,
                width: displayWidth(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
