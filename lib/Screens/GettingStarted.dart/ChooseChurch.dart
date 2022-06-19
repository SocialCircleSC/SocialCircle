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


  //List<Map<String, dynamic>> allChurches = [];

  final List<Map<String, dynamic>> allChurches = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> foundChurches = [];

  getData() async {
    await FirebaseFirestore.instance.collection("Churches").orderBy('Church Name', descending: true).get().then((value) {
      for(var i in value.docs) {
        allChurches.add(i.data());
      }
    });
  }


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
                child: foundChurches.isNotEmpty
                    ? ListView.builder(
                        itemCount: foundChurches.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(allChurches[index].toString()),
                            subtitle: Text(
                                '${allChurches[index].toString()} '),
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





// Padding(
//           padding: CenterPadding,
//           child: Column(children: [
//             const SizedBox(
//               height: 100,
//             ),
//             Text("Find Your Church!", style: titleText),
//             SizedBox(
//               height: 20,
//             ),

//             TextButton(
//               style: TextButton.styleFrom(
//                 primary: WhiteColor,
//                 backgroundColor: PrimaryColor,
//                 padding: CenterPadding,
//               ),
//               child: Text("Or Add My Church!"),
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => NavBar()));
//               },
//             ),
//           ]),
//         ),


//Alt Search Bar
// TextEditingController searchController = TextEditingController();
//   List churches = [];

//   late Future resultsLoaded;

//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(() {
//       onSearchChanged;
//     });
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(() {
//       onSearchChanged();
//     });
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     resultsLoaded = getChurchList();
//   }

//   getChurchList() async {
//     var data = await FirebaseFirestore.instance
//         .collection("Churches") 
//         .get()
//         .then((QuerySnapshot querySnapShot) {
//       for (var doc in querySnapShot.docs) {
//         churches.add(doc["Church Name"]);
//       }
//     });

//     data;

//     return churches;
//   }
  

//   onSearchChanged() {
//     //Make it show a list like the other search bar
//     print(churches);
//   }
