import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing Stripe"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //makePayment();
          },
          child: const Text("Pay Me!"),
        ),
      ),
    );
  }
}
