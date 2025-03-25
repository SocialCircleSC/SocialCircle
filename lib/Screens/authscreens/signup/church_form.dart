// ignore_for_file: unused_local_variable, use_build_context_synchronously
import 'package:socialorb/Screens/authscreens/signup/confirm_signup.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:socialorb/themes/theme.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socialorb/Screens/authscreens/signup/subscription.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialorb/Screens/authscreens/signup/secure_storage.dart';


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
  bool _isLoading = false;

  final auth = FirebaseAuth.instance;
  TextEditingController churchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController weeklyEventController = TextEditingController();

  WebViewController? _webViewController;

  // Verify with Stripe that onboarding was successful
  Future<bool> verifyOnboardingSuccess(String accountId) async {
    final url = Uri.parse('https://api.stripe.com/v1/accounts/$accountId');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_TEST_SECRET']!}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if the account is properly set up
        // This will depend on what capabilities you need
        bool isDetailsSubmitted = data['details_submitted'] == true;
        bool isPayoutsEnabled = data['payouts_enabled'] == true;
        
        debugPrint("Account verification - Details submitted: $isDetailsSubmitted, Payouts enabled: $isPayoutsEnabled");
        
        // You can customize this based on your requirements
        // For testing, you might want to relax this to just check details_submitted
        return isDetailsSubmitted; // && isPayoutsEnabled;
      } else {
        debugPrint("Failed to verify account status: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error verifying account: $e");
      return false;
    }
  }

  void launchOnboardingLink(String url, String chName, String chAddress, String chEmail, String chPhoneN, String chWeekE, String cStripeID) {
    if (url.isEmpty) {
      Fluttertoast.showToast(msg: "Onboarding link not generated. Please try again.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            debugPrint("Page started loading: $url");
            
            if (url.contains("social-orb.com")) {
              // User reached the return URL, close WebView
              Navigator.of(context).pop(); // Close WebView
              
              // Show loading indicator while verifying account status
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: PrimaryColor),
                      SizedBox(height: 16),
                      Text("Verifying account setup...", style: TextStyle(color: WhiteColor)),
                    ],
                  ),
                ),
              );
              
              // Verify with Stripe
              bool success = await verifyOnboardingSuccess(cStripeID);
              
              // Close loading indicator
              Navigator.of(context).pop();
              
              if (success) {
                // Onboarding successful, proceed to confirmation page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubScreen(churchStripeID: cStripeID,
                      churchName: chName, 
                      churchAddress: chAddress, 
                      email: chEmail, 
                      phoneNumber: chPhoneN, 
                      weeklyEvent: chWeekE),
                  ),
                );
              } else {
                Fluttertoast.showToast(msg: "Account setup not completed. Please try again.");
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Webview Error: ${error.description}");
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Error loading page. Please try again.");
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigation Request: ${request.url}");

            if (request.url.contains("social-orb.com")) {
              // This is the success return URL, handle in onPageStarted
              return NavigationDecision.navigate;
            } else if (request.url.contains("google.com")) {
              // This is the failure/refresh URL
              Navigator.of(context).pop(); // Close WebView
              Fluttertoast.showToast(msg: "Onboarding interrupted. Try again.");
              setState(() {
                _isLoading = false;
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Stripe Onboarding",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: "Onboarding cancelled.");
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: WebViewWidget(controller: _webViewController!),
                ),
              ],
            ),
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

        _isLoading
            ? const CircularProgressIndicator(color: PrimaryColor)
            : TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: PrimaryColor,
                  padding: SignUpButtonPadding,
                ),
                child: const Text("Sign Up"),
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    Fluttertoast.showToast(
                        msg: "Please make sure your password is the same as your confirm password");
                  } else if (churchNameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      phoneNumberController.text.isEmpty ||
                      weeklyEventController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please fill out all the forms");
                  } else {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Step 1: Create Stripe Account
                      await createStripeAccount(
                          emailController.text, 
                          churchNameController.text, 
                          addressController.text
                      );

                      // Step 2: Generate Onboarding Link
                      if (aID.isNotEmpty) {
                        await generateOnboardingLink(aID);

                        if (oID.isNotEmpty) {
                          await SecureStorageService.savePassword(confirmPasswordController.text);
                          launchOnboardingLink(
                            oID, 
                            churchNameController.text,
                            addressController.text,
                            emailController.text,
                            phoneNumberController.text,
                            weeklyEventController.text,
                            aID,
                          );
                        } else {
                          Fluttertoast.showToast(msg: "Failed to generate onboarding link. Please try again.");
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Failed to create Stripe account. Please try again.");
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } catch (e) {
                      debugPrint("Error with onboarding: $e");
                      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
      ],
    );
  }

  //Get Stripe account ID
  Future<void> createStripeAccount(String email, String cName, String cAddress) async {
    final url = Uri.parse('https://api.stripe.com/v1/accounts');

    try {
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
        setState(() {
          aID = data['id'];
        });
        debugPrint("Stripe account created: $aID");
      } else {
        debugPrint("Failed to create Stripe account: ${response.body}");
        throw Exception('Failed to create Stripe account: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Exception creating Stripe account: $e");
      throw Exception('Network error creating Stripe account: $e');
    }
  }

  //Generate onboarding link
  Future<void> generateOnboardingLink(String acID) async {
    final url = Uri.parse('https://api.stripe.com/v1/account_links');

    try {
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
          'type': 'account_onboarding',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          oID = data['url'];
        });
        debugPrint("Onboarding link generated: $oID");
      } else {
        debugPrint("Failed to generate onboarding link: ${response.body}");
        throw Exception('Failed to generate onboarding link: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Exception generating onboarding link: $e");
      throw Exception('Network error generating onboarding link: $e');
    }
  }
}