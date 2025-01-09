import 'package:socialorb/Screens/authscreens/signup/subscription.dart';
import 'package:socialorb/notifications/push_noti.dart';
import 'package:socialorb/screens/messaging/message_home.dart';
import 'package:socialorb/screens/navscreens/navbar/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialorb/Screens/AuthScreens/Login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'dart:async';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "lib/.env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  await Stripe.instance.applySettings();

  FirebaseAuth.instance.authStateChanges().listen((event) {
    if (event == null) {
      // Force device to be in portrait mode
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        runApp(MainPage());
      });
    } else {
      // Force device to be in portrait mode
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        runApp(const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: NavBar(),
        ));
      });
    }
  });
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription? _deepLinkSub;

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessageHome()),
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void _setupDeepLinkListener() {
    _deepLinkSub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.path == 'www.social-orb.com/onboard') {
        // Navigate to SubScreen when the deep link is detected
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubScreen()),
        );
      }
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }



  @override
  void initState() {
    super.initState();

    // Initialize push notifications
    initPushNotifications();

    // Set up deep link listener
    _setupDeepLinkListener();

    // Request notification permissions
    firebaseMessaging.requestPermission();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message while in foreground: ${message.notification?.title}");
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message.notification!.title ?? "Notification"),
            content: Text(message.notification!.body ?? "No content"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK")),
            ],
          ),
        );
      }
    });

    // Handle when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavBar()));
    });
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
