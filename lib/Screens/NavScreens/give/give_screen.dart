import 'package:socialorb/screens/navscreens/give/keyboard_key.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({Key? key}) : super(key: key);

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  final payController = CardFormEditController();

  Map<String, dynamic>? paymentIntent;

  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client-secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "SocialOrb",
        googlePay: gpay,
      ));

      displayPaymentSheet();
    } catch (e) {}
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint("DONE");
    } catch (e) {
      debugPrint("FAILED");
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "US",
      };

      http.Response response = await http.post(
          Uri.parse("http://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET']!}",
            "Content-Type": "application/x-www-form-urlendcoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
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
                        debugPrint("Ok Ok");
                        makePayment();
                        debugPrint("Last Last");
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Confirm'),
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
}
