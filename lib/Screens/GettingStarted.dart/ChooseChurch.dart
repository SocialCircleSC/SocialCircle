// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:community/Screens/NavScreens/NavBar/NavBar.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:community/firestore/GetChurches.dart';
import 'package:firestore_search/firestore_search.dart';

class ChooseChurch extends StatefulWidget {
  const ChooseChurch({Key? key}) : super(key: key);

  @override
  State<ChooseChurch> createState() => _ChooseChurchState();
}

class _ChooseChurchState extends State<ChooseChurch> {
  String searchString = "";

  List<Map<String, dynamic>> allChurches = [];

  // This list holds the data for the list view
  List<Map<String, dynamic>> foundChurches = [];

  Future getChurchList() async {
    List<Map<String, dynamic>> answer = [];

    var data = await FirebaseFirestore.instance
        .collection('Churches')
        .orderBy('Church Name', descending: true)
        .get()
        .then((value) {
      for (var i in value.docs) {
        answer.add({"name": i.data()});
      }
    });

    setState(() {
      allChurches = answer;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChurchList();
  }

  @override
  initState() {
    // at the beginning, all users are shown
    foundChurches = allChurches;
    super.initState();
  }

  void filterChurches(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allChurches;
    } else {
      results = allChurches
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundChurches = results;
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
          automaticallyImplyLeading: false,
          title: const Text(
            'Almost There!',
            style: TextStyle(color: WhiteColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => filterChurches(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: allChurches.isNotEmpty //Found Churches
                    ? ListView.builder(
                        itemCount: allChurches.length, //FoundChurches
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(allChurches[index].toString()),
                            subtitle: Text('${allChurches[index].toString()} '),
                          ),
                        ),
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
