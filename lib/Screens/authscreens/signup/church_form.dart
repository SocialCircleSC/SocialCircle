// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:socialorb/Screens/authscreens/signup/subscription.dart';
import 'package:socialorb/firestore/ChurchSignUpData.dart';
import 'package:socialorb/screens/authscreens/login/login_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:socialorb/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class SignUpFormChurch extends StatefulWidget {
  final int planID;
  const SignUpFormChurch({Key? key, required this.planID}) : super(key: key);

  @override
  State<SignUpFormChurch> createState() => _SignUpFormChurchState();
}

enum SingingCharacter {starter, standard, premium, payg }

class _SignUpFormChurchState extends State<SignUpFormChurch> {
  bool _isObscure = false;
  bool checkedValue = false;
  bool newValue = true;
  String empty = "empty";
  String customerStripeID = "";
  String paymentMethodID = "";
  String connectedAccountID = "";
  String customerID = "";
  String priceID = ""; //This will be permanent
  Map<String, dynamic>? paymentIntent;
  var jsonR;
  String aID = "";
  String oID = "";

  final auth = FirebaseAuth.instance;
  TextEditingController churchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController weeklyEventController = TextEditingController();

//late WebViewController _webViewController;

  WebViewController? _webViewController;

  void launchOnboardingLink(String url) async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (url.contains("www.social-orb.com")) {
              Navigator.of(context).pushNamedAndRemoveUntil('/SubScreen', (route) => false);
            }
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebViewWidget(controller: _webViewController!),
          ),
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        //Church Name Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: churchNameController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Church Name",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        // Address Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: addressController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Address(Include City and Zip Code)",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Email Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: emailController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Phone Number Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: phoneNumberController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Event1 Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            controller: weeklyEventController,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: "Add one weekly event",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
            ),
          ),
        ),

        //Text about adding more events
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child:
                Text("Don't worry you will be able to add more events later")),

        //Password Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            obscureText: !_isObscure,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        //Confirm Password Controller
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(45)],
            obscureText: !_isObscure,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: const TextStyle(color: TextFieldColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),

        SizedBox(
          height: displayHeight(context) * 0.01,
        ),

        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: WhiteColor,
            backgroundColor: PrimaryColor,
            padding: SignUpButtonPadding,
          ),
          child: const Text("Sign Up"),
          onPressed: () async {
            if (passwordController.text != confirmPasswordController.text) {
              Fluttertoast.showToast(
                  msg:
                      "Please make sure your password is the same as your confirm passowrd");
            } else if (churchNameController.text.isEmpty ||
                addressController.text.isEmpty ||
                emailController.text.isEmpty ||
                phoneNumberController.text.isEmpty ||
                weeklyEventController.text.isEmpty ||
                passwordController.text.isEmpty ||
                confirmPasswordController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please fill out all the forms");
            } else {
              if (passwordController.text != confirmPasswordController.text) {
                Fluttertoast.showToast(
                    msg:
                        "Please make sure your password is the same as your confirm passowrd");
              } else {

                try{
                    //Phase 1
                    debugPrint("Phase 1");

                    // Step 1: Create Stripe Account
                    createStripeAccount(emailController.text, churchNameController.text, addressController.text);

                    debugPrint(aID);

                    //Phase 2
                    debugPrint("Phase 2");
                    // Step 2: Generate Onboarding Link
                    generateOnboardingLink(aID);



                     //Phase 3
                    debugPrint("Phase 3");
                    // Step 3: Redirect User to Onboarding
                    debugPrint(oID);
                    
                    launchOnboardingLink(oID);
                    // if(await launchUrl(Uri.parse(oID))){
                    //   await launchUrl(Uri.parse(oID));
                    // }else{
                    //   debugPrint('Could not launch url Link');
                    // }
                    
                    




                    //Phase 4
                    debugPrint("Phase 4");
                    // Step 4: Save Account Details to Firebase Server
                    //signUp(emailController.text, passwordController.text, aID);
                    //Phase 5
                      debugPrint("Phase 5");
                  } catch (e){
                    debugPrint("Error with onboarding");
                }
              }
            }
          },
        ),
      ],
    );
  }

  //Get Stripe account ID
  void createStripeAccount(String email, String cName, String cAddress) async {
    //Change secret key
     final url = Uri.parse('https://api.stripe.com/v1/accounts');

      final response = await http.post(
      url,
      headers: {
      'Authorization': 'Bearer ${dotenv.env['STRIPE_TEST_SECRET']!}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'type': 'express',
      'email': email, 
      // 'individual[first_name]': cName,
      // 'individual[address][line1]': cAddress,
    },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //aID = data['id'];
      setState(() {
        aID = data['id'];
      });
       // The stripe accounT ID
    } else {
      throw Exception('Failed to create Stripe account: ${response.body}');
    }

  }

  //Generate the onboarding
  void generateOnboardingLink(String acID) async {
    final url = Uri.parse('https://api.stripe.com/v1/account_links');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_TEST_SECRET']!} ', 
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      //This seems to be the issue

      body: {
        'account': acID,
        'refresh_url': 'https://www.youtube.com', // URL to reinitiate onboarding if interrupted https://your-app.com/reauth
        'return_url': 'https://www.google.com', // URL to redirect after successful onboarding https://your-app.com/success
        'type': 'account_onboarding',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // setState(() {
      //   oID = data['url'];
      // });
      debugPrint(data['url']);
      oID = data['url'];
      
    } else {
      throw Exception('Failed to create onboarding link: ${response.body}');
    }
  }

  

  //SignUp
  void signUp(String email, String password, String accID) async {

    //Remember to save account ID
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await churchSetup(churchNameController.text, addressController.text, 
        phoneNumberController.text, emailController.text, 
        weeklyEventController.text, accID);


      

      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: "Congrats on making an account. Please login to use the app",
          toastLength: Toast.LENGTH_LONG);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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





  