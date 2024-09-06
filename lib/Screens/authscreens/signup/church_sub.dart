import 'dart:convert';
import 'dart:developer';



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/Screens/NavScreens/navbar/nav_bar.dart';
import 'package:socialorb/Screens/authscreens/signup/church_signup.dart';
import 'package:socialorb/firestore/changePlan.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChurchSub extends StatefulWidget {
  final String churchID;

  const ChurchSub({super.key, required this.churchID});

  @override
  State<ChurchSub> createState() => _ChurchSubState();
}

class _ChurchSubState extends State<ChurchSub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Choose Your Plan"),
      ),

      body: HorizontalCardScroll(churchValue: widget.churchID,),
    );
  }
}

class HorizontalCardScroll extends StatelessWidget {
  late final String churchValue;

    // Accept value via constructor
  HorizontalCardScroll({required this.churchValue});


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCard(context,'Starter Pack: \$60', '200' , PrimaryColor, 1, churchValue),
          _buildCard(context, 'Classic Pack: \$120', '500', PrimaryColor, 2, churchValue),
          _buildCard(context, 'Exclusive Pack: \$500', '2000', PrimaryColor, 3, churchValue),
          _buildCard(context, 'Social Pack: \$1200', '5000', PrimaryColor, 4, churchValue),
        ],
      ),
    );
  }

}

Widget _buildCard(BuildContext contextz,String title, String churchSize ,Color color, int code, String cID){

  List<String> featureList = [
    "Text to Give",
    "Media Engagement",
    "Outreach and Community Collaboration",
    "Messaging",
    "Annoucements",
    "Event Mangement"
  ];

  return Container(
    width: 300, // Adjust the width of the card
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 140),
      decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 5.0,
        ),
        ],
      ),

          child: Column(
            
            children: <Widget>[
              Container(
                child:  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    title + " Monthly",
                    style: const TextStyle(color: BlackColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  ),
                ),
              ),

              Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Max Members: $churchSize",
                    style: TextStyle(color: BlackColor, fontSize: 23),
                  ),
                ),
              ),

              Container(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Features",
                    style: TextStyle(color: BlackColor, fontSize: 23),
                  ),
                ),
              ),

              Container(
                child: Column(
                  children: featureList.map((e) => Text(e)).toList(),
                )
              ),

              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: ElevatedButton(
                    onPressed: (){
                      showPreparation(contextz, code, cID);
                  }
                  ,
                    child: Text("Select"),
                    style: ElevatedButton.styleFrom(
                      primary: WhiteColor,
                    ),
                    ),
                ),
              ),


            ],
          ),
  );
}


void showPreparation(BuildContext context, int planID, String churchID){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Almost done"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main text
            const Text('An email about switching to the new plan will be sent to you in the next 2-3 business days.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                
                                

            // Spacing between the list and the buttons
            SizedBox(height: 20),

            // Row with two buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async{
                    editPlan(churchID, planID);
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const NavBar()));
                    Fluttertoast.showToast(
                      msg: "An email about purchasing your new plan will be sent to you in the next 2-3 business days.",
                      toastLength: Toast.LENGTH_LONG,  // Show toast for a longer duration
                      gravity: ToastGravity.BOTTOM,     // Position the toast at the bottom of the screen
                      fontSize: 16.0,                   // Font size
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}



































