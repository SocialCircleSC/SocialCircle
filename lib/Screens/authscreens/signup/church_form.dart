// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:socialorb/firestore/ChurchSignUpData.dart';
import 'package:socialorb/screens/authscreens/login/login_screen.dart';

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

  final auth = FirebaseAuth.instance;
  TextEditingController churchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController weeklyEventController = TextEditingController();

  //@override

  // void initState(){
  //   super.initState();

  //       // Listen for URL changes in the WebView
  //   flutterWebViewPlugin.onUrlChanged.listen((String url) {
  //     if (url.contains("your_redirect_url")) {
  //       // The user has reached the redirect URL
  //       // Close the WebView
  //       flutterWebViewPlugin.close();

  //       // Navigate back to Flutter
  //       Navigator.of(context).pop();
  //     }
  //   });
  // }
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

                  //Before steps 
                  //await createPaymentIntent();


                  // //1) Collect payment info
                  // await collectPaymentInfo();

                  // debugPrint("Done1");

                  // //2)Create connected account
                  // connectedAccountID = await createConnectedAccount(emailController.text);
                  // debugPrint("Done2");
                  // //3) Attach Payment to Customer
                  // customerID = await createCustomer(emailController.text);
                  // debugPrint("Done3");
                  // //4) Set Up recurring payment
                  // await createSubscription(customerID, dotenv.env['STRIPE_STARTER_ID']!);

                  // debugPrint("Done4");
                  // //5) Redirect to complete onboarding
                  // await redirectToOnboarding(connectedAccountID);
                  // debugPrint("Done5");

                  //6) Sign them up
                  signUp(emailController.text, passwordController.text);
                  //debugPrint("Done?");
                  //7) Redirect back to app
                  //_launchURL(widget.planID);
                  
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

  void signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await churchSetup(churchNameController.text, addressController.text, 
        phoneNumberController.text, emailController.text, 
        weeklyEventController.text);


      

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

  Future<void> createPaymentIntent() async {
     try {
        final Map<String, dynamic> body = {
        'amount': '2000', // The amount in the smallest currency unit (e.g., cents for USD)
        'currency': 'usd', // The currency
        'payment_method_types[]': 'card', // Payment methods
      };

      
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${dotenv.env['STRIPE_SECRET']!}', //SecretKey used here
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      jsonR = jsonDecode(response.body);
      jsonR = jsonR['clientSecret'];

      //log('Payment Intent Body->>> ${response.body.toString()}'); 
      //return jsonDecode(response.body);
    } catch (e) {
      debugPrint('err charging user: ${e.toString()}');
    }
  }

  Future<void> collectPaymentInfo() async {
      debugPrint("Done1");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: const SetupPaymentSheetParameters(
          //paymentIntentClientSecret: clientSecret,
          // Customize the appearance of the payment sheet
          style: ThemeMode.dark, // or ThemeMode.light
          merchantDisplayName: 'SocialOrb',
        ),
      );
    
      debugPrint("Done2");
      try{
        await Stripe.instance.presentPaymentSheet();
        var paymentMethod = await Stripe.instance.confirmPayment(paymentIntentClientSecret: 'plink_1PovKyEdOD179lXVUqEILO8j');//Need to create payment intent for recurring payment of 60
        //And put it as a parameter
      
         showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: SecondaryColor,
                      ),
                    ),
                    Text("Payment Info Saved"),
                  ],
                ),
              ],
            ),
          ),
        );
      
      
      paymentMethodID = paymentMethod.id;
      
      } catch (e){
        debugPrint(e.toString());
      }
      //paymentMethod;
      paymentMethodID;
      debugPrint("Done3");
    
  }

  //Create connected account
  Future<String> createConnectedAccount(String email) async {
    final url = Uri.parse('https://api.stripe.com/v1/accounts');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'type': 'express',
        'email': email,
      },
    );
    if (response.statusCode == 200) {
      final accountData = jsonDecode(response.body);
      final accountID = accountData['id'];
      connectedAccountID = accountData['id'];
      return accountID;
     
    } else {
      throw Exception('Failed to create connected account: ${response.body}');
    }
}


Future<void> attachPaymentMethodToCustomer(
    String paymentMethodId, String customerId) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'customer': customerId,
    },
  );

  if (response.statusCode == 200) {
    print('Payment method attached to customer: $customerId');
  } else {
    throw Exception('Failed to attach payment method: ${response.body}');
  }
}

Future<void> redirectToOnboarding(String accountId) async {
  final url = Uri.parse('https://api.stripe.com/v1/account_links');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'account': accountId,
      'return_url': 'social-orb.com',
      'type': 'account_onboarding',
    },
  );

  if (response.statusCode == 200) {
    final linkData = jsonDecode(response.body);
    final onboardingUrl = linkData['url'];
    //await launch(onboardingUrl);
  } else {
    throw Exception('Failed to create account link: ${response.body}');
  }
}

Future<void> createSubscription(String customerId, String priceId) async {
  final url = Uri.parse('https://api.stripe.com/v1/subscriptions');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'customer': customerId,
      'items[0][price]': priceId,
    },
  );

  if (response.statusCode == 200) {
    final subscriptionData = jsonDecode(response.body);
    final subscriptionId = subscriptionData['id'];
    print('Subscription created: $subscriptionId');
  } else {
    throw Exception('Failed to create subscription: ${response.body}');
  }
}




  //Create a church recuring payment link to be used
  Future<String> createCustomer(String email) async {
    final url = Uri.parse('https://api.stripe.com/v1/customers');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']!}', 
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      customerStripeID = body['id'];
      return body['id']; // This is the customer ID
    } else {
      throw Exception('Failed to create customer: ${response.body}');
    }
  }


}


