import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({Key? key}) : super(key: key);

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Image(
                  image: AssetImage('lib/assets/churchImage.jpg'),
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: semiLeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "The Grace of God Ministries",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: semiLeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "125 Hurch Avenue Bronx, NY 10466",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: semiLeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "We are a Christian Fellowship striving to help those in need. We welcome you to our loving community, and hope you continue to grow with us",
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: 15,
                        fontFamily: '',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: semiLeftPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "See Hours",
                      style: TextStyle(
                        color: PrimaryColor,
                        fontSize: 15,
                        fontFamily: '',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // SizedBox(
                //   height: 15,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Hours: ",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Mondays:  Prayer Meeting 9:00 PM - 10:00 PM",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Tuesday:  Worship Night 6:00 PM - 7:00 PM",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Wednesday:  Bible Study 6:00 PM - 7:00 PM",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Friday:  Food Pantry 3:00 PM - 5:00 PM",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: semiLeftPadding,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Sunday:  Sunday Service 10:00 AM - 1:00 PM",
                //       style: TextStyle(
                //         color: BlackColor,
                //         fontSize: 15,
                //         fontFamily: 'Roboto',
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
                // ),
                Divider(
                  color: BlackColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Posts and Replies",
                  style: TextStyle(
                    color: BlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        debugShowCheckedModeBanner: false, //Removing Debug Banner
      ),
    );
  }
}
