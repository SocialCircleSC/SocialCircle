import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialorb/firestore/addMemberMessage.dart';
import 'package:socialorb/firestore/createGroup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/firestore/removeMemberMessage.dart';

import '../../themes/theme.dart';

class AddMembers extends StatefulWidget {
  final String churchID;
  final String userID;
  final String combName;
  final String documentID;
  const AddMembers(
      {super.key,
      required this.churchID,
      required this.userID,
      required this.combName, 
      required this.documentID});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  String name = "";
  bool tempBool = false;
  List addList = [];
  TextEditingController nameController = TextEditingController();
  bool checkedValue = false;

  Future getListOfMembers(String churchID, String userID, String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // ignore: unused_local_variable
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where("Church ID", isEqualTo: widget.churchID)
        .get()
        .then((value) {
      for (int i = 0; i < value.size; i++) {
        if (value.docs[i].id == name) {
          setState(() {
            tempBool == true;
          });
        }
      }
    });
  }

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
                    addMemberMessage(widget.churchID, widget.userID, widget.documentID);
                    Fluttertoast.showToast(
                        msg: "Added a member",
                        toastLength: Toast.LENGTH_LONG);   
                  
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Add Members")),
                                  TextButton(
                                  onPressed: () async{
                                     //End
                    removeMemberMessage(widget.churchID, widget.userID, widget.documentID);
                    Fluttertoast.showToast(
                        msg: "Added a member",
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
              .collection("users")
              .where("Church ID", isEqualTo: widget.churchID)
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
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(width: 4, color: BlackColor),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image:
                                        NetworkImage(data["ProfilePicture"]))),
                          ),
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
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(width: 4, color: BlackColor),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage(
                                                  data["ProfilePicture"]))),
                                    ),
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
