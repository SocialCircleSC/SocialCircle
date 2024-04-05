import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialorb/firestore/addMemberMessage.dart';
import 'package:socialorb/firestore/createGroup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/firestore/removeMemberMessage.dart';

import '../../themes/theme.dart';

class RemoveMembers extends StatefulWidget {
  final String churchID;
  final String userID;
  final String combName;
  final String documentID;
  const RemoveMembers(
      {super.key,
      required this.churchID,
      required this.userID,
      required this.combName, 
      required this.documentID});

  @override
  State<RemoveMembers> createState() => _RemoveMembersState();
}

class _RemoveMembersState extends State<RemoveMembers> {
  String name = "";
  bool tempBool = false;
  List addList = [];
  TextEditingController nameController = TextEditingController();
  bool checkedValue = false;


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
          title: Column(
            children: [
              Card(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Members",
                  ),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async{
                  if (addList.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please select one or more members",
                        toastLength: Toast.LENGTH_LONG);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                  TextButton(
                                  onPressed: () async{
                                     //End
                    removeMemberMessage(widget.churchID, widget.userID, widget.documentID);
                    Fluttertoast.showToast(
                        msg: "Remove a member",
                        toastLength: Toast.LENGTH_LONG);   
                  
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Remove Members")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              ],
                            ),
                          
                          );
                        });

                  }
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: SecondaryColor),
                ))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(widget.churchID)
              .collection("messages")
              .where("Members", arrayContains: widget.userID)
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
              //Data[ID] is not in the collection change it
              return ListView.builder(                               
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (name.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              if (addList.contains(data["ID"])) {
                                addList.remove(data["ID"]);
                              } else {
                                addList.add(data["ID"]);
                              }
                            });
                          },
                          tileColor: addList.contains(data["ID"])
                              ? PrimaryColor
                              : WhiteColor,
                          
                          title: Text(
                              data["First Name"] + " " + data["Last Name"]),
                        ),
                      );
                    }

                    if (data['First Name']
                            .toString()
                            .toLowerCase()
                            .contains(name.toLowerCase()) ||
                        data['Last Name']
                            .toString()
                            .toLowerCase()
                            .contains(name.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {},
                          child: 
                            
                              Column(
                                children: [
                                
                                  ListTile(
                                    title: Text(
                                        data["First Name"] + " " + data["Last Name"]),
                                  ),
                                ],
                              ),
                           
                        ),
                      );
                    }
                    return Container();
                  });
            }
          },
        ),
      ),
    );
  }
}
