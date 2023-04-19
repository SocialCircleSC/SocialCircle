import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/firestore/changeStatus.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/sizes/size.dart';
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

    //Get List of Status
    // await FirebaseFirestore.instance
    //     .collection('circles')
    //     .doc(cID)
    //     .get()
    //     .then((value) {
    //   listStat = List.from(value["ListStatus"]);
    // });

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
            if (snapshot1.connectionState == ConnectionState.waiting ||
                !snapshot1.hasData) {
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
                              AnimatedSmoothIndicator(
                                activeIndex: list.indexWhere((f) => f == e),
                                count: list.length,
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
                                title: const Center(
                                  child: Text(
                                    "Members",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
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
                                                    title: Text(
                                                        memberList[index]
                                                                ['First Name']
                                                            .toString()),
                                                    subtitle: Text(
                                                        memberList[index]
                                                                ['Status']
                                                            .toString()),
                                                    trailing:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton2(
                                                        hint: const Text(
                                                            "Status"),
                                                        items: snapshot1
                                                            .data!["ListStatus"]
                                                            .map<
                                                                DropdownMenuItem<
                                                                    String>>((item) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: item,
                                                                  child: Text(
                                                                    item,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: selectedValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            changeStat(
                                                                memberList[index]
                                                                        ['ID']
                                                                    .toString(),
                                                                churchID,
                                                                selectedValue
                                                                    .toString());
                                                          });
                                                        },
                                                        buttonStyleData:
                                                            const ButtonStyleData(
                                                          height: 40,
                                                          width: 140,
                                                        ),
                                                        menuItemStyleData:
                                                            const MenuItemStyleData(
                                                          height: 40,
                                                        ),
                                                      ),
                                                    )),
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
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Events",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
                                  title: Text(
                                      snapshot1.data!["Events"][0].toString()),
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
                      itemCount: getEvents(snapshot1.data!["Events"])),
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
