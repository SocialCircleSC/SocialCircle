import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:socialorb/Screens/authscreens/signup/subscription.dart';
import 'package:socialorb/Screens/authscreens/signup/church_form.dart';
import 'dart:async';

class DeepLinkHandler {
  StreamSubscription? sub;

  void init(BuildContext context) {
    sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.host == "www.social-orb.com/onboard") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubScreen()),
          );
        } else if (uri.host == "www.social-orb.com/about-us") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpFormChurch(planID: 0,)),
          );
        }
      }
    });
  }

  void dispose() {
    sub?.cancel();
  }
}