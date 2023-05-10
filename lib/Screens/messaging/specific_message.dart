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
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    messages.add(MessageModel(
                        text: data['Text'],
                        date: (data['TimeStamp'] as Timestamp).toDate(),
                        isSentByMe: data['isSentByMe']));

                    return SizedBox(
                      height:
                          displayWidth(context) - AppBar().preferredSize.height,
                      child: Column(
                        children: [
                          Expanded(
                            child: GroupedListView<MessageModel, DateTime>(
                              reverse: true,
                              order: GroupedListOrder.DESC,
                              padding: const EdgeInsets.all(8),
                              elements: messages,
                              groupBy: (message) => DateTime(
                                message.date.year,
                                message.date.month,
                                message.date.day,
                              ),
                              groupHeaderBuilder: (MessageModel message) =>
                                  SizedBox(
                                height: 40,
                                child: Center(
                                  child: Card(
                                    color: SecondaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        DateFormat.yMMMd().format(message.date),
                                        style:
                                            const TextStyle(color: WhiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              itemBuilder: (context, MessageModel element) {
                                return Align(
                                  alignment: data['isSentByMe']
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: data['isSentByMe']
                                      ? Card(
                                          color: PrimaryColor,
                                          elevation: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(data['Text']),
                                          ),
                                        )
                                      : Card(
                                          color: WhiteColor,
                                          elevation: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(data['Text']),
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        fillColor: PrimaryColor,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        hintText: "Start typing here...",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(24))),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.send))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
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