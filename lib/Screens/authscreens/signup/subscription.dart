import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialorb/Screens/authscreens/login/login_screen.dart';
import 'package:socialorb/Screens/authscreens/signup/secure_storage.dart';
import 'package:socialorb/firestore/ChurchSignUpData.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:socialorb/themes/theme.dart';

class SubScreen extends StatefulWidget {
  final String churchStripeID;
  final String churchName;
  final String churchAddress;
  final String email;
  final String phoneNumber;
  final String weeklyEvent;

  const SubScreen({
    Key? key,
    required this.churchStripeID,
    required this.churchName,
    required this.churchAddress,
    required this.email,
    required this.phoneNumber,
    required this.weeklyEvent,
  }) : super(key: key);

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  bool _isLoading = false;
  
  // Define subscription plans
  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'free',
      'name': 'Free Pack',
      'price': '\$0',
      'code': 1,
      'maxMembers': 50,
      'paymentLink': 'free_plan',
      'description': 'Basic features for up to 50 members',
      'color': Color(0xFF073D5F),
    },
    {
      'id': 'starter',
      'name': 'Classic Pack',
      'price': '\$29',
      'code': 2,
      'maxMembers': 200,
      'paymentLink': 'https://buy.stripe.com/test_28oeWudnK0dK0ZafZ5',
      'description': 'Standard features for up to 200 members',
      'color': Color(0xFF20BAB1),
    },
    {
      'id': 'standard',
      'name': 'Exclusive Pack',
      'price': '\$120',
      'code': 3,
      'maxMembers': 500,
      'paymentLink': 'https://buy.stripe.com/test_00g01Aaby3pWeQ0fZ6',
      'description': 'Premium features for up to 500 members',
      'color': Color(0xFF9E35F7),
    },
    {
      'id': 'premium',
      'name': 'Social Pack',
      'price': '\$400',
      'code': 4,
      'maxMembers': 2000,
      'paymentLink': 'https://buy.stripe.com/test_dR67u2bfCgcI9vG14d',
      'description': 'All features for up to 2000 members',
      'color': Color(0xFFF76C35),
    },
  ];

  WebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text(
          "Choose Your SocialOrb Plan",
          style: TextStyle(color: WhiteColor),
        ),
        iconTheme: const IconThemeData(color: WhiteColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: PrimaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select a subscription plan for your church:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You can change or cancel your plan at any time.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        final plan = _plans[index];
                        return _buildPlanCard(context, plan);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: plan['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  plan['price'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Up to ${plan['maxMembers']} members",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handlePlanSelection(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                      foregroundColor: WhiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Select Plan",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlanSelection(Map<String, dynamic> plan) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For free plan, create account directly
      if (plan['id'] == 'free') {
        await _createAccountWithPlan(plan);
        return;
      }

      // For paid plans, show Stripe payment WebView
      await _showPaymentWebView(plan);
    } catch (e) {
      debugPrint("Error handling plan selection: $e");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createAccountWithPlan(Map<String, dynamic> plan) async {
    try {
      String? securePassword = await SecureStorageService.getPassword();
      
      if (securePassword == null || securePassword.isEmpty) {
        Fluttertoast.showToast(msg: "Password retrieval failed. Please try again.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create Firebase Auth account
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: securePassword);

      // Setup church with subscription data
      await churchSetup(
          widget.churchName, 
          widget.churchAddress, 
          widget.phoneNumber, 
          widget.email, 
          widget.weeklyEvent, 
          widget.churchStripeID
      );

      Fluttertoast.showToast(msg: "Account created successfully! Please login.");
      
      // Navigate to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("Error creating account: $e");
      Fluttertoast.showToast(msg: "Account creation failed: ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showPaymentWebView(Map<String, dynamic> plan) async {
    final paymentUrl = plan['paymentLink'];
    
    if (paymentUrl == null || paymentUrl.isEmpty) {
      Fluttertoast.showToast(msg: "Payment link not available. Please try again.");
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
            
            // Check for successful payment
            if (url.contains("checkout/completed")) {
              Navigator.of(context).pop(); // Close WebView
              
              // Show loading indicator while creating account
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: PrimaryColor),
                      SizedBox(height: 16),
                      Text("Creating your account...", style: TextStyle(color: WhiteColor)),
                    ],
                  ),
                ),
              );
              
              await _createAccountWithPlan(plan);
              
              // Close loading dialog (if it's still open)
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Error loading payment page. Please try again.");
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));

    // Show WebView in dialog
    await showDialog(
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
                  backgroundColor: PrimaryColor,
                  title: const Text("SocialOrb Payment", style: TextStyle(color: WhiteColor)),
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: WhiteColor),
                    onPressed: () {
                      Navigator.of(context).pop();
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

    // If we get here without account creation, reset loading state
    setState(() {
      _isLoading = false;
    });
  }
}