import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialorb/Screens/NavScreens/give/pay_with_card.dart';
import 'package:socialorb/firestore/giveFirestore.dart';
import 'package:socialorb/screens/navscreens/give/keyboard_key.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({Key? key}) : super(key: key);

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  final payController = CardFormEditController();
  String stripeID = "";
  String receiptE = "";

  Map<String, dynamic>? paymentIntent;

    //Get the member's church ID
  Future getStripeConnectedID() async {
    String sID = "";
    String cID = "";
    String rEmail = "";

    //Get church ID
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
      rEmail = value.get('Email Address');
    });

    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .get()
        .then((value) {
      sID = value.get('Stripe Connected ID');
    });

    setState(() {
      stripeID = sID;
      receiptE = rEmail;
    });
  }

    @override
  void didChangeDependencies() {
    getStripeConnectedID();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    payController.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void dispose() {
    payController.removeListener(update);
    payController.dispose();
    super.dispose();
  }

  String amount = "";
  List<List<dynamic>> keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', const Icon(Icons.keyboard_backspace)]
  ];

  onKeyTap(String val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount + val;
    });
  }

  onBackspacePress() {
    if (amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount.substring(0, amount.length - 1);
    });
  }

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
            children: x.map((y) {
              return Expanded(
                child: KeyboardKey(
                  label: y,
                  value: y,
                  onTap: (val) {
                    if (val is Widget) {
                      onBackspacePress();
                    } else {
                      onKeyTap(val);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        )
        .toList();
  }

  renderAmount() {
    String display = '\$';
    if (amount.isNotEmpty) {
      NumberFormat f = NumberFormat('#,###');

      display = '\$${f.format(int.parse(amount))}';
    }
    return Expanded(
        child: Center(
            child: Text(
      display,
      style: const TextStyle(
          fontSize: 35, fontWeight: FontWeight.bold, color: PrimaryColor),
    )));
  }

  renderConfirmButtom() {
    //  async {
    //                     Navigator.of(context).push(MaterialPageRoute(
    //                         builder: (context) =>  const StripeGive(link: '',)));
    //                   }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: SecondaryColor,
                    disabledBackgroundColor: Colors.grey[200]),
                onPressed: amount.isNotEmpty
                    ? () async {
                         makePayment();
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Confirm', style: TextStyle(color: WhiteColor),),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 120.0),
          child: Column(children: [
            renderAmount(),
            ...renderKeyboard(),
            renderConfirmButtom(),
          ]),
        ),
      ),
    );
  }




  //For Stripe
    createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'transfer_group': stripeID,
        'receipt_email': receiptE,
      };

      
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${dotenv.env['STRIPE_SECRET']!}', //SecretKey used here
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      log('Payment Intent Body->>> ${response.body.toString()}'); 
      return jsonDecode(response.body);
    } catch (e) {
      log('err charging user: ${e.toString()}');
    }
  }

  calculateAmount(String amount) {
    amount = "${amount}00";
    final calculatedAmout = (int.parse(amount));
    return calculatedAmout.toString();
  }

  Future<void> makePayment() async {
    try {
      
      paymentIntent = await createPaymentIntent(amount, 'USD');

     
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          customerId: paymentIntent!['customer'],
          style: ThemeMode.light, 
          merchantDisplayName: 'SocialOrb',
        ),
      )
          .then((value) {
            log("Success");
            
      });

      
      displayPaymentSheet(); // Payment Sheet
    } catch (e, s) {
      String ss = "exception 1 :$e";
      String s2 = "reason :$s";
      log("exception 1:$e");
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
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
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );
        paymentIntent = null;
      }).onError((error, stackTrace) {
        String ss = "exception 2 :$error";
        String s2 = "reason :$stackTrace";
      });
    } on StripeException catch (e) {
      //print('Error is:---> $e');
      String ss = "exception 3 :$e";
    } catch (e) { 
      log('$e');
    }
    giveFirestore(int.parse(amount));
  }

  final client = http.Client();
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']!}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  Future<Map<String, dynamic>> _createCustomer() async {
    const String url = 'https://api.stripe.com/v1/customers';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {'description': 'new customer'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log(json.decode(response.body));
      throw 'Failed to register as a customer.';
    }
  }
}
