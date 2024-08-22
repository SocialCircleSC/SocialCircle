import 'dart:convert';
import 'dart:developer';



import 'package:flutter/material.dart';
import 'package:socialorb/Screens/authscreens/signup/church_signup.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChurchSub extends StatefulWidget {
  const ChurchSub({super.key});

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

      body: HorizontalCardScroll(),
    );
  }
}

class HorizontalCardScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCard(context,'Starter Pack: \$60', '200' , PrimaryColor, 1),
          _buildCard(context, 'Classic Pack: \$120', '500', PrimaryColor, 2),
          _buildCard(context, 'Exclusive Pack: \$500', '2000', PrimaryColor, 3),
          _buildCard(context, 'Social Pack: \$1200', '5000', PrimaryColor, 4),
        ],
      ),
    );
  }

}

Widget _buildCard(BuildContext contextz,String title, String churchSize ,Color color, int code){

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
                      showPreparation(contextz, code);
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


void showPreparation(BuildContext context, int planID){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Before Continuing"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main text
            const Text('The process of registration can take up to 15 minutes. To make sure the process is as fast and smooth as possible, please have the following before pressing continue.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 20),
                                
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('• ID Card of a financial and personal representative of the church'),
                                    Text('• Address of the Church'),
                                    Text('• Debit/Credit Card for payment'),
                                    Text('• Social Security Number'),
                                    Text("• Website. If non use 'www.social-orb.com' "),
                                    Text('• Atleast 15 minutes of time'),
                                    Text('• Once done you will be provided a code needed to move the next phase. Please Save that code', style:  TextStyle(color: SecondaryColor),),
                                  ],
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
                  onPressed: () {
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpChurch(planID: planID)),
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



































