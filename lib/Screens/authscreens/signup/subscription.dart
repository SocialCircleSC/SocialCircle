import 'dart:convert';
import 'dart:developer';



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/Screens/NavScreens/navbar/nav_bar.dart';
import 'package:socialorb/Screens/authscreens/signup/church_signup.dart';
import 'package:socialorb/firestore/changePlan.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});



  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Choose Your Plan"),
      ),

      body: HorizontalCardScroll(),
    );
  }
}

class HorizontalCardScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildModernCard(context, 'Free Pack: \$0', '200', 1),
          _buildModernCard(context, 'Classic Pack: \$30', '500', 2),
          _buildModernCard(context, 'Exclusive Pack: \$120', '5000', 3),
          _buildModernCard(context, 'Social Pack: \$500', '10000', 4),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, String title, String churchSize, int code) {
    List<String> featureList = [
      "Text to Give",
      "Media Engagement",
      "Outreach and Community Collaboration",
      "Messaging",
      "Announcements",
      "Event Management",
      "Unlimited Guests",
    ];

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
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
          // Header
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Max Members: $churchSize",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Features:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...featureList.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                

              ],
            ),
          ),

          // Footer with Button
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action for selecting this plan
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
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






































