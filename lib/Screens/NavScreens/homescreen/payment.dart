import 'dart:async';

import 'package:community/screens/authscreens/signup/church_form.dart';
import 'package:community/screens/navscreens/homescreen/payment_webview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../firestore/churchSignUpData.dart';
import '../../../themes/theme.dart';
import '../navbar/nav_bar.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RecurringPayment extends StatefulWidget {
  final String email;
  final String password;
  final String churchName;
  final String churchAddress;
  final String phoneNumber;
  final String weeklyEvent;

  const RecurringPayment(
      {super.key,
      required this.email,
      required this.password,
      required this.churchName,
      required this.churchAddress,
      required this.phoneNumber,
      required this.weeklyEvent});

  @override
  State<RecurringPayment> createState() => _RecurringPaymentState();
}

class _RecurringPaymentState extends State<RecurringPayment> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      show(context);
    });
  }

  String url = "";

  SingingCharacter? _character = SingingCharacter.starter;
  String plan = "Starter";
  List<String> paymentPlans = ["Starter", "Standard", "Premium", "PAYG"];

  final Uri starterUri = Uri.parse(dotenv.env['STRIPE_STARTER_URI']!);

  final Uri standardUri = Uri.parse(dotenv.env['STRIPE_STANDARD_URI']!);
  final Uri premiumUri = Uri.parse(dotenv.env['STRIPE_PREMIUM_URI']!);

  final Uri paygUri = Uri.parse(dotenv.env['STRIPE_PAYG_URI']!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text('Complete Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: SecondaryColor),
                onPressed: () {
                  show(context);
                },
                child: const Text(
                  "Payment Details",
                )),
          ],
        ),
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              const Text(
                "Choose Your Plan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Details: All plans share the same features. The difference in price is based on the size of your church ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Features: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "1) Tithes and Offering portal ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "2) Unlimited Messaging between all Church members",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "3) Online enagement dashboard for all members to share stories, annoucements prayers and more!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "To select a plan, press the circle next to plan, then the plan itself in order to confirm",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: PrimaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    ListTile(
                      title: const Text("Starter Plan: \$39.99"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.starter,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      subtitle: const Text("Max Members: 200"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: const Text("Standard Plan: \$59.99"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.standard,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      subtitle: const Text("Max Members: 500"),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: const Text("Premium Plan: \$129.99"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.premium,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      subtitle: const Text("Max Members: 1000"),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: const Text("Pay As You Grow Plan: \$199.99"),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.payg,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      subtitle: const Text(
                          "Base Members: 1500 (+\$25 per 250 additional members)"),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_character == SingingCharacter.starter) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentWebView(
                                  churchAddress: widget.churchAddress,
                                  churchName: widget.churchName,
                                  email: widget.email,
                                  password: widget.password,
                                  phoneNumber: widget.phoneNumber,
                                  type: "starter",
                                  weeklyEvent: widget.weeklyEvent,
                                )));
                  } else if (_character == SingingCharacter.standard) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentWebView(
                                  churchAddress: widget.churchAddress,
                                  churchName: widget.churchName,
                                  email: widget.email,
                                  password: widget.password,
                                  phoneNumber: widget.phoneNumber,
                                  type: "standard",
                                  weeklyEvent: widget.weeklyEvent,
                                )));
                  } else if (_character == SingingCharacter.premium) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentWebView(
                                  churchAddress: widget.churchAddress,
                                  churchName: widget.churchName,
                                  email: widget.email,
                                  password: widget.password,
                                  phoneNumber: widget.phoneNumber,
                                  type: "premium",
                                  weeklyEvent: widget.weeklyEvent,
                                )));
                  } else if (_character == SingingCharacter.payg) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentWebView(
                                  churchAddress: widget.churchAddress,
                                  churchName: widget.churchName,
                                  email: widget.email,
                                  password: widget.password,
                                  phoneNumber: widget.phoneNumber,
                                  type: "payg",
                                  weeklyEvent: widget.weeklyEvent,
                                )));
                  }
                },
                child: const Text("Pay"),
                style:
                    ElevatedButton.styleFrom(backgroundColor: SecondaryColor),
              ),
            ],
          );
        });
  }

  void paymentWebhook(Uri link) async {
    //final String url = link;
    var response = await http.Client().post(
      link,
      headers: {
        'Authorization': 'Bearer ' + dotenv.env['STRIPE_SECRET']!,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {'description': 'Test user'},
    );
    if (response.statusCode == 200) {
      debugPrint(json.decode(response.body));
    } else {
      log(json.decode(response.body));
      throw 'Failed to register as a customer.';
    }
  }
}
