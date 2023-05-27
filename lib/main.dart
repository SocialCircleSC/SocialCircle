import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:community/Screens/AuthScreens/Login/login_screen.dart';
import 'package:flutter/services.dart';


//Things to work on
// The show/hide password icon not working responsively.
Future<void> main() async {
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     "pk_test_51N8yrxEdOD179lXVPatM50pacKj371QQZgulC2rGoMUqYjRRlLwwPtw4tgsDyFUq37nlS1YP6WqYyFAcVSNDU5Xl007TgETRGA";
  // await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  //Force device to be in portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainPage());
  });
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
