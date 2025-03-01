// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:socialorb/Screens/AuthScreens/signup/general_signup.dart';
import 'package:socialorb/Screens/authscreens/signup/confirm_signup.dart';
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
  
  const SignUpFormChurch({Key? key, required bool guest}) : super(key: key);

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
  String cID = "";

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

void launchOnboardingLink(String url, String chName, String chAddress, String chEmail, String chPhoneN, String chWeekE, String cStripeID) {
  if (url.isEmpty) {
    Fluttertoast.showToast(msg: "Press Again");
    return;
  }

  _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {

          if (url.contains("social-orb.com")) {
            // User successfully completes onboarding
            //Navigator.of(context).pop(); // Close WebView
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmSignUp(
                churchStripeID: cStripeID,
                churchName: chName,
                churchAddress: chAddress,
                email: chEmail,
                phoneNumber: chPhoneN,
                weeklyEvent: chWeekE,
              ),
            ),
          );

          }
        },
        onPageFinished: (String url) {
          debugPrint("Page finished loading: $url");
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint("Webview Error: ${error.description}");
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Press Again");
        },
        onNavigationRequest: (NavigationRequest request) {
          debugPrint("Navigation Request: ${request.url}");

          if (request.url.contains("google.com")) {
            // User interrupted onboarding (refresh or back button)
            Navigator.of(context).pop(); // Close WebView
            Fluttertoast.showToast(msg: "Onboarding interrupted. Try again.");
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
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
                    // Step 1: Create Stripe Account
                    createStripeAccount(emailController.text, churchNameController.text, addressController.text);

                    // Step 2: Generate Onboarding Link
                    generateOnboardingLink(aID);


                    if(oID != null){
                      launchOnboardingLink(oID, churchNameController.text, 
                        addressController.text,
                        emailController.text,
                        phoneNumberController.text,
                        weeklyEventController.text,
                        aID,
                      );
                    } else{
                      Fluttertoast.showToast(msg: "Press Again");
                    }
                    
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

    //Generate onboarding link
    void generateOnboardingLink(String acID) async {
      final url = Uri.parse('https://api.stripe.com/v1/account_links');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_TEST_SECRET']!}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'account': acID,
          'refresh_url': 'https://google.com',
          'return_url': 'https://www.social-orb.com',
          //'cancel_url': 'https://google.com',
          'type': 'account_onboarding',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //oID = data['url']
        setState(() {
          oID = data['url'];
        });
        launchOnboardingLink(oID, churchNameController.text, addressController.text, emailController.text, phoneNumberController.text, weeklyEventController.text, acID);
      } else {
        Fluttertoast.showToast(msg: "Press Again");
      }
    }

  }




  