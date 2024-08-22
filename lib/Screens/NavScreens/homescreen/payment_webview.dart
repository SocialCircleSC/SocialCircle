// ignore_for_file: use_build_context_synchronously

import 'package:socialorb/Screens/AuthScreens/Login/login_screen.dart';
import 'package:socialorb/screens/navscreens/navbar/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../firestore/churchSignUpData.dart';

class PaymentWebView extends StatefulWidget {
  final String email;
  final String password;
  final String churchName;
  final String churchAddress;
  final String phoneNumber;
  final String weeklyEvent;
  final String type;
  const PaymentWebView(
      {super.key,
      required this.email,
      required this.password,
      required this.churchName,
      required this.churchAddress,
      required this.phoneNumber,
      required this.weeklyEvent,
      required this.type});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  // ignore: prefer_typing_uninitialized_variables
  var controller;
  String link = "";
  @override
  void initState() {
    super.initState();
    if (widget.type == 'starter') {
      setState(() {
        link = dotenv.env['STRIPE_STARTER_URI']!;
      });
    } else if (widget.type == 'standard') {
      setState(() {
        link = dotenv.env['STRIPE_STANDARD_URI']!;
      });
    } else if (widget.type == 'premium') {
      setState(() {
        link = dotenv.env['STRIPE_PREMIUM_URI']!;
      });
    } else {
      setState(() {
        link = dotenv.env['STRIPE_PAYG_URI']!;
      });
    }
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
              signUp(widget.email, widget.password);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              Fluttertoast.showToast(
                  msg:
                      "Your account has been made. Please relogin to use your account",
                  toastLength: Toast.LENGTH_LONG);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Payment Page"),
        ),
        body: WebViewWidget(controller: controller));
  }

  void signUp(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: widget.password);

      // churchSetup(
      //   widget.churchName,
      //   widget.churchAddress,
      //   widget.phoneNumber,
      //   widget.email,
      //   widget.weeklyEvent,
      // );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavBar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The Password is too weak");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Email already exists");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

//THIS IS OLAOLUWA OLOJEDE'S CODE. Also Demon Slayer Season 3 was a Banger man!! 6/19/2023