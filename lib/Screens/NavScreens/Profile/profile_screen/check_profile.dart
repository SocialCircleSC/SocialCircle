import 'package:flutter/material.dart';

import '../../../../themes/theme.dart';

class CheckProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String status;
  final String profilePic;
  const CheckProfile(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.status,
      required this.profilePic});

  @override
  State<CheckProfile> createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: PrimaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 45,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: WhiteColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.profilePic))),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "${widget.firstName} ${widget.lastName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Center(
              child: Text(
                "Status: ${widget.status}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: SizedBox(
              width: 100,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: WhiteColor,
                  backgroundColor: SecondaryColor,
                ),
                child: const Text("Message"),
                onPressed: () {},
              ),
            )),
          ],
        ),
      ),
    );
  }
}
