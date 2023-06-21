import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/firestore/sendMessage.dart';
import 'package:community/screens/messaging/message_model.dart';
import 'package:flutter/material.dart';

import '../../themes/theme.dart';

class SpecificMessage extends StatefulWidget {
  final String churchID;
  final String userID;
  final String documentID;
  final String name;
  final String title;
  final String sender;

  const SpecificMessage({
    super.key,
    required this.churchID,
    required this.userID,
    required this.documentID,
    required this.name,
    required this.sender,
    required this.title,
  });

  @override
  State<SpecificMessage> createState() => _SpecificMessageState();
}

class _SpecificMessageState extends State<SpecificMessage> {
  List<MessageModel> messages = [];
  TextEditingController newMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
            backgroundColor: PrimaryColor,
            elevation: 0,
            leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: BlackColor,
              ),
            ),
            title: Text(widget.title)),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(widget.churchID)
              .collection("messages")
              .doc(widget.documentID)
              .collection('interactions')
              .orderBy('TimeStamp', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            } else {
              return Stack(
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                              left: snapshot.data!.docs[index]['Sender'] ==
                                      widget.userID
                                  ? 0
                                  : 24,
                              right: snapshot.data!.docs[index]['Sender'] ==
                                      widget.userID
                                  ? 24
                                  : 0),
                          alignment: snapshot.data!.docs[index]['Sender'] ==
                                  widget.userID
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: snapshot.data!.docs[index]['Sender'] ==
                                    widget.userID
                                ? const EdgeInsets.only(left: 25)
                                : const EdgeInsets.only(right: 25),
                            padding: const EdgeInsets.only(
                                top: 17, bottom: 17, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: snapshot.data!.docs[index]['Sender'] ==
                                        widget.userID
                                    ? PrimaryColor
                                    : WhiteColor,
                                borderRadius: snapshot.data!.docs[index]
                                            ['Sender'] ==
                                        widget.userID
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (snapshot.data!.docs[index]['Sender'] !=
                                    widget.userID)
                                  Text(
                                    snapshot.data!.docs[index]['Name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: SecondaryColor,
                                        letterSpacing: -0.5),
                                  ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  snapshot.data!.docs[index]['Text'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13.5),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newMessage,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[700],
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText: "Start typing here...",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(24))),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (newMessage.text.isEmpty) {
                                } else {
                                  sendMessage(
                                      widget.churchID,
                                      widget.userID,
                                      widget.documentID,
                                      "text",
                                      newMessage.text,
                                      widget.name);
                                }

                                newMessage.text = "";
                              },
                              icon: const Icon(Icons.send)),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
