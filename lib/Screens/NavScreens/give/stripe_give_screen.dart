import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/navscreens/give/give_screen.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeGive extends StatefulWidget {
  final String link;
  const StripeGive({super.key, required this.link});

  @override
  State<StripeGive> createState() => _StripeGiveState();
}

class _StripeGiveState extends State<StripeGive> {
  // ignore: prefer_typing_uninitialized_variables
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CircularProgressIndicator(),
              ],
            );
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.social-orb.com')) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GiveScreen()));
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
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SecondaryColor,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
