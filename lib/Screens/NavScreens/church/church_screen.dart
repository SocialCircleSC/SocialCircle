import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/firestore/addNewEvent.dart';
import 'package:community/firestore/addNewStatus.dart';
import 'package:community/firestore/deleteEvent.dart';
import 'package:community/firestore/changeStatus.dart';
import 'package:community/firestore/deleteStatus.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({Key? key}) : super(key: key);

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  //getChurchInfo
  String churchID = " ";
  String userID = "";
  String firstName = "";
  String lastName = "";
  String status = "";
  var memberList;
  var list;
  List<DropdownMenuItem<String>> statusList = [];

  Future getCurrentChurch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var cID;
    var fireList;
    var fName;
    var lName;
    var stat;
    var members;
    var listStat;

    //Get ChurchID
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      cID = value.get('Church ID');
    });

    //Get churchInfo
    await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .get()
        .then((value) {
      fireList = value.get('Pictures');
      fName = value.get("First Name");
      lName = value.get("Last Name");
      stat = value.get("Status");
    });

    //Get list of members
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('circles')
        .doc(cID)
        .collection('members')
        .orderBy("First Name")
        .get();

    members = query.docs.map((doc) => doc.data()).toList();

    setState(() {
      churchID = cID;
      userID = uid.toString();
      list = fireList;
      firstName = fName;
      lastName = lName;
      status = stat;
      memberList = members;
      //listStatus = listStat;
      //statusList = listStat;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentChurch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;
  TextEditingController statusController = TextEditingController();
  TextEditingController eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("circles")
              .doc(churchID)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return SingleChildScrollView(
                child: Wrap(
              children: <Widget>[
                CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      height: 300,
                    ),
                    items: list.map<Widget>(((e) {
                      return Builder(builder: (BuildContext context) {
                        return GestureDetector(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  e,
                                  width: displayWidth(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AnimatedSmoothIndicator(
                                  activeIndex: list.indexWhere((f) => f == e),
                                  count: list.length,
                                  effect: const ScrollingDotsEffect(
                                    dotHeight: 7,
                                    dotWidth: 7,
                                    activeDotScale: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    })).toList()),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    firstName + " " + lastName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Center(
                  child: Text(
                    "Status: " + status,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: WhiteColor,
                        backgroundColor: SecondaryColor,
                      ),
                      child: const Text("Members"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Members",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 103,
                                      ),
                                      if (userID == churchID)
                                        ElevatedButton(
                                            child: const Text("Status"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: PrimaryColor,
                                                foregroundColor: WhiteColor),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Column(
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              statusController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: 1,
                                                          // ignore: prefer_const_constructors
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Type Your New Status",
                                                            // ignore: prefer_const_constructors
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          PrimaryColor),
                                                            ),
                                                            // ignore: prefer_const_constructors
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          PrimaryColor),
                                                            ),
                                                            // ignore: prefer_const_constructors
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          PrimaryColor),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Fluttertoast.showToast(
                                                                msg: statusController
                                                                        .text +
                                                                    " has been added",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT);
                                                            setState(() {
                                                              statusController
                                                                  .text = "";
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Add"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      PrimaryColor,
                                                                  foregroundColor:
                                                                      WhiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                    content: SizedBox(
                                                      height: 200,
                                                      width: 400,
                                                      child: ListView.separated(
                                                          shrinkWrap: true,
                                                          itemBuilder: (context,
                                                              index2) {
                                                            return Card(
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              child:
                                                                  ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                  minHeight:
                                                                      displayHeight(
                                                                              context) *
                                                                          0.07,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title: Text(snapshot1
                                                                          .data![
                                                                              "ListStatus"]
                                                                              [
                                                                              index2]
                                                                          .toString()),
                                                                      // trailing: IconButton(
                                                                      //     onPressed: () {
                                                                      //       deleteStat(churchID,
                                                                      //           snapshot1.data!["ListStatus"][index2]);
                                                                      //     },
                                                                      //     icon: const Icon(Icons.delete_forever_outlined)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const Divider(
                                                              height: 10,
                                                              thickness: 0.5,
                                                            );
                                                          },
                                                          itemCount: snapshot1
                                                              .data![
                                                                  "ListStatus"]
                                                              .length),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child:
                                                            const Text("Done"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            })
                                    ],
                                  ),
                                ),
                                content: SizedBox(
                                  height: 400,
                                  width: 600,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          clipBehavior: Clip.antiAlias,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight:
                                                  displayHeight(context) * 0.07,
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(memberList[index]
                                                              ['First Name']
                                                          .toString() +
                                                      " " +
                                                      memberList[index]
                                                              ['Last Name']
                                                          .toString()),
                                                  subtitle: Text(
                                                      memberList[index]
                                                              ['Status']
                                                          .toString()),
                                                  trailing: userID == churchID
                                                      ? TextButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        "Change Status",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        SizedBox(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          400,
                                                                      child: ListView.separated(
                                                                          shrinkWrap: true,
                                                                          itemBuilder: (context, index1) {
                                                                            return Card(
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: ConstrainedBox(
                                                                                constraints: BoxConstraints(
                                                                                  minHeight: displayHeight(context) * 0.07,
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    ListTile(
                                                                                      title: Text(snapshot1.data!["ListStatus"][index1].toString()),
                                                                                      onTap: () async {
                                                                                        changeStat(memberList[index]['ID'].toString(), churchID, snapshot1.data!["ListStatus"][index1].toString());
                                                                                        //Reload List
                                                                                        QuerySnapshot query = await FirebaseFirestore.instance.collection('circles').doc(churchID).collection('members').orderBy("First Name").get();
                                                                                        setState(() {
                                                                                          memberList = query.docs.map((doc) => doc.data()).toList();
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          separatorBuilder: (context, index) {
                                                                            return const Divider(
                                                                              height: 10,
                                                                              thickness: 0.5,
                                                                            );
                                                                          },
                                                                          itemCount: snapshot1.data!["ListStatus"].length),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        child: const Text(
                                                                            "Done"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: const Text(
                                                            "Edit",
                                                            style: TextStyle(
                                                                color:
                                                                    PrimaryColor),
                                                          ))
                                                      : Text(" "),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          height: 10,
                                          thickness: 0.5,
                                        );
                                      },
                                      itemCount: memberList.length),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (userID == churchID)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: WhiteColor,
                          backgroundColor: SecondaryColor,
                        ),
                        child: const Text("Edit"),
                        onPressed: () {},
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: BlackColor,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Events",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      TextField(
                                        controller: eventController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 1,
                                        // ignore: prefer_const_constructors
                                        decoration: const InputDecoration(
                                          hintText: "Type New Event",
                                          // ignore: prefer_const_constructors
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: PrimaryColor),
                                          ),
                                          // ignore: prefer_const_constructors
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: PrimaryColor),
                                          ),
                                          // ignore: prefer_const_constructors
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: PrimaryColor),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          addNewEven(
                                              churchID, eventController.text);
                                          Fluttertoast.showToast(
                                              msg: eventController.text +
                                                  " has been added",
                                              toastLength: Toast.LENGTH_SHORT);
                                          setState(() {
                                            eventController.text = "";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Add"),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: PrimaryColor,
                                            foregroundColor: WhiteColor),
                                      ),
                                    ],
                                  ),
                                  content: SizedBox(
                                    height: 200,
                                    width: 400,
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index3) {
                                          return Card(
                                            clipBehavior: Clip.antiAlias,
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight:
                                                    displayHeight(context) *
                                                        0.07,
                                              ),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(snapshot1
                                                        .data!["Events"][index3]
                                                        .toString()),
                                                    trailing: IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Confirm"),
                                                                content: Text("Are you sure you want to delete " +
                                                                    snapshot1
                                                                        .data![
                                                                            "Events"]
                                                                            [
                                                                            index3]
                                                                        .toString()),
                                                                actions: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "Yes"),
                                                                    onPressed:
                                                                        () {
                                                                      deleteEvent(
                                                                          churchID,
                                                                          snapshot1.data!["Events"]
                                                                              [
                                                                              index3]);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child:
                                                                        const Text(
                                                                            "No"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(Icons
                                                            .delete_forever_outlined)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            height: 10,
                                            thickness: 0.5,
                                          );
                                        },
                                        itemCount:
                                            snapshot1.data!["Events"].length),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Done"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.add)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 285,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: displayHeight(context) * 0.07,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(snapshot1.data!["Events"][index]
                                      .toString()),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 10,
                          thickness: 0.5,
                        );
                      },
                      itemCount: snapshot1.data!["Events"].length),
                ),
              ],
            ));
          }),
    );
  }
}

getEvents(document) {
  int likeCount = 0;
  var exMap;
  exMap = document;
  likeCount = exMap.length;
  return likeCount;
}
