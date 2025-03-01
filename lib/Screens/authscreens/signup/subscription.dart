import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialorb/Screens/authscreens/login/login_screen.dart';
import 'package:socialorb/firestore/ChurchSignUpData.dart';
import 'package:url_launcher/url_launcher.dart';

class SubScreen extends StatefulWidget {
  final String churchStripeID;
  final String churchName;
  final String churchAddress;
  final String email;
  final String phoneNumber;
  final String weeklyEvent;

  const SubScreen({
    Key? key,
    required this.churchStripeID,
    required this.churchName,
    required this.churchAddress,
    required this.email,
    required this.phoneNumber,
    required this.weeklyEvent,
  }) : super(key: key);

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Final Step: Choose Plan"),
      ),
      body: HorizontalCardScroll(widget: widget),
    );
  }
}

class HorizontalCardScroll extends StatelessWidget {
  final SubScreen widget;
  HorizontalCardScroll({Key? key, required this.widget}) : super(key: key);

  final Map<int, String> planPaymentLinks = {
    1: "PAYMENT_LINK_HERE_FREE", 
    2: "https://buy.stripe.com/test_28oeWudnK0dK0ZafZ5",
    3: "https://buy.stripe.com/test_00g01Aaby3pWeQ0fZ6",
    4: "https://buy.stripe.com/test_dR67u2bfCgcI9vG14d",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildModernCard(context, 'Free Pack: \$0', 1, widget),
          _buildModernCard(context, 'Classic Pack: \$29', 2, widget),
          _buildModernCard(context, 'Exclusive Pack: \$120', 3, widget),
          _buildModernCard(context, 'Social Pack: \$400', 4, widget),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, String title, int code, SubScreen widget) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF073D5F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF20BAB1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String? paymentLink = planPaymentLinks[code];

                  //Go to payment link site or create account based on data
                  if (paymentLink != null) {
                     if(paymentLink == "Free"){
                     await churchSetup(widget.churchName, widget.churchAddress, widget.phoneNumber, widget.email, widget.weeklyEvent, widget.churchStripeID);
                     Fluttertoast.showToast(msg: "All done! Feel free to Login Now.");
                     // ignore: use_build_context_synchronously
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );

                     }else{
                        _launchURL(context, paymentLink);
                        //Keep track of which was pressed then go to payment link
                        //This can be done using if statementsd or case statements to know which was clicked on
                        //Once done create acc in church setup 
                        //Go back to login page
                     }
                    
                  } else {
                    Fluttertoast.showToast(msg: "Error retrieving payment link.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Select",
                  style: TextStyle(
                    color: Color(0xFF073D5F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fluttertoast.showToast(msg: "Try Again");
  }
}
