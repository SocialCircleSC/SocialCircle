// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:socialorb/screens/navscreens/homescreen/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserOnboard extends StatefulWidget {
  final String email;
  final String password;
  final String churchName;
  final String churchAddress;
  final String phoneNumber;
  final String weeklyEvent;
  const UserOnboard({super.key, required this.email, required this.password, required this.churchName, required this.churchAddress, required this.phoneNumber, required this.weeklyEvent});

  @override
  State<UserOnboard> createState() => _UserOnboardState();
}

class _UserOnboardState extends State<UserOnboard> {
  var controller;
  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.social-orb.com')) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecurringPayment(email: widget.email, password: widget.password, churchName: widget.churchName, churchAddress: widget.churchAddress, phoneNumber: widget.phoneNumber, weeklyEvent: widget.weeklyEvent)));
              Fluttertoast.showToast(
                  msg:
                      "Thanks for giving! A receipt has been sent to your email.",
                  toastLength: Toast.LENGTH_LONG);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(dotenv.env['STRIPE_ONBOARDING']!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Information for Tithes, Offering and Donations")),
      body: WebViewWidget(controller: controller),
    );
  }
}