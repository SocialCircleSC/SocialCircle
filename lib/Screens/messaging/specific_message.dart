import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/screens/messaging/message_model.dart';
import 'package:community/sizes/size.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../themes/theme.dart';

class SpecificMessage extends StatefulWidget {
  final String churchID;
  final String userID;
  final String documentID;

  const SpecificMessage(
      {super.key,
      required this.churchID,
      required this.userID,
      required this.documentID});

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
            title: Text(widget.documentID)),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(widget.churchID)
              .collection("members")
              .doc(widget.userID)
              .collection("messages")
              .doc(widget.documentID)
              .collection('interactions')
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
                              left: snapshot.data!.docs[index]['isSentByMe']
                                  ? 0
                                  : 24,
                              right: snapshot.data!.docs[index]['isSentByMe']
                                  ? 24
                                  : 0),
                          alignment: snapshot.data!.docs[index]['isSentByMe']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: snapshot.data!.docs[index]['isSentByMe']
                                ? const EdgeInsets.only(left: 25)
                                : const EdgeInsets.only(right: 25),
                            padding: const EdgeInsets.only(
                                top: 17, bottom: 17, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: snapshot.data!.docs[index]['isSentByMe']
                                    ? PrimaryColor
                                    : WhiteColor,
                                borderRadius: snapshot.data!.docs[index]
                                        ['isSentByMe']
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
                                if (snapshot.data!.docs[index]['isSentByMe'] ==
                                    false)
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
                            child: TextFormField(
                              controller: newMessage,
                              decoration: InputDecoration(
                                  fillColor: PrimaryColor,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText: "Start typing here...",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(24))),
                            ),
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.send))
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

// itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     var data = snapshot.data!.docs[index].data()
//                         as Map<String, dynamic>;

//                     messages.add(MessageModel(
//                         text: data['Text'],
//                         date: (data['TimeStamp'] as Timestamp).toDate(),
//                         isSentByMe: data['isSentByMe']));
