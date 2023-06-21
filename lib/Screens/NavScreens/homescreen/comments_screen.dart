// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/firestore/commentPost.dart';
import 'package:community/firestore/delete_comment.dart';

import 'package:community/screens/navscreens/homescreen/edit_post.dart';
import 'package:flutter/material.dart';


import '../../../sizes/size.dart';
import '../../../themes/theme.dart';
import '../profile/profile_screen/check_profile.dart';

class Comments extends StatefulWidget {
  final String profilePic;
  final String firstName;
  final String lastName;
  final String status;
  final String text;
  final String type;
  final List postPicture;
  final List postVideo;
  final int pictureLength;
  final String churchID;
  final String userID;
  final String postID;
  final String likes;
  final List likesArr;
  final bool likeStatus;

  const Comments(
      {super.key,
      required this.profilePic,
      required this.firstName,
      required this.lastName,
      required this.status,
      required this.text,
      required this.type,
      required this.postPicture,
      required this.postVideo,
      required this.churchID,
      required this.userID,
      required this.postID,
      required this.likes,
      required this.likeStatus,
      required this.pictureLength,
      required this.likesArr});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        backgroundColor: WhiteColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text("Comment"),
                      content: TextField(
                        controller: postTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          hintText: "Start Typing",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Post"),
                          onPressed: () {
                            postComment(
                                postTextController.text,
                                widget.status,
                                widget.firstName,
                                widget.lastName,
                                widget.churchID,
                                widget.userID,
                                widget.postID,
                                widget.profilePic);
                            postTextController.text = "";
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }),
                );
              },
              child: const Icon(
                Icons.comment,
                color: BlackColor,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            )
          ],
          title: const Text(
            'Comments',
            style: TextStyle(color: SecondaryColor),
          ),
          leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: SecondaryColor,
            ),
          ),
        ),
        body: StreamBuilder(
            //change here
            stream: FirebaseFirestore.instance
                .collection("circles")
                .doc(widget.churchID)
                .collection("posts")
                .doc(widget.postID)
                .collection("comments")
                .limit(25)
                .orderBy('TimeStamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                child: Column(
                  children: <Widget>[
                    // This box is from the post clicked.
                    SizedBox(
                      height: displayHeight(context) * 0.84,
                      child: ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Column(
                            children: [
                              //Selected Post

                              //The Comments from Streambuilder
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckProfile(
                                              firstName: document['First Name'],
                                              lastName: document['Last Name'],
                                              status: document['Status'],
                                              profilePic:
                                                  document['ProfilePicture'])));
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight:
                                            displayHeight(context) * 0.1),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: displayHeight(context) * 0.01,
                                        ),
                                        ListTile(
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 4,
                                                    color: BlackColor),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: NetworkImage(document[
                                                        "ProfilePicture"]))),
                                          ),
                                          title: Text(document['First Name'] +
                                              " " +
                                              document['Last Name']),
                                          subtitle: Text(
                                            document['Status'],
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              document['Text'],
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.8)),
                                            ),
                                          ),
                                        ),
                                        // if (document["Type"] == "Image")
                                        //   //Only show image if it exists
                                        //   Padding(
                                        //     padding: const EdgeInsets.all(1.0),
                                        //     child: Align(
                                        //       alignment: Alignment.centerLeft,
                                        //       child: Stack(
                                        //         children: [
                                        //           CarouselSlider(
                                        //               options: CarouselOptions(
                                        //                 viewportFraction: 1,
                                        //                 enlargeCenterPage: true,
                                        //                 enableInfiniteScroll:
                                        //                     false,
                                        //                 height: displayHeight(
                                        //                         context) *
                                        //                     0.55,
                                        //               ),
                                        //               items: document['Picture']
                                        //                   .map<Widget>(((e) {
                                        //                 return Builder(builder:
                                        //                     (BuildContext
                                        //                         context) {
                                        //                   return GestureDetector(
                                        //                     onTap: () {
                                        //                       Navigator.push(
                                        //                           context,
                                        //                           MaterialPageRoute(
                                        //                               builder: (context) =>
                                        //                                   BiggerPicture(
                                        //                                       picture: e)));
                                        //                     },
                                        //                     child: Stack(
                                        //                       alignment: Alignment
                                        //                           .bottomCenter,
                                        //                       children: [
                                        //                         ClipRRect(
                                        //                           borderRadius:
                                        //                               BorderRadius
                                        //                                   .circular(
                                        //                                       7),
                                        //                           child: Image
                                        //                               .network(
                                        //                             e,
                                        //                             width: displayWidth(
                                        //                                 context),
                                        //                             fit: BoxFit
                                        //                                 .cover,
                                        //                           ),
                                        //                         ),
                                        //                         if (document[
                                        //                                     'Picture']
                                        //                                 .length !=
                                        //                             1)
                                        //                           AnimatedSmoothIndicator(
                                        //                             activeIndex: document[
                                        //                                     "Picture"]
                                        //                                 .indexWhere((f) =>
                                        //                                     f ==
                                        //                                     e),
                                        //                             count: document[
                                        //                                     'Picture']
                                        //                                 .length,
                                        //                           ),
                                        //                       ],
                                        //                     ),
                                        //                   );
                                        //                 });
                                        //               })).toList()),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // if (document["Type"] == "Video")
                                        //   Align(
                                        //     alignment: Alignment.center,
                                        //     child: SizedBox(
                                        //       height:
                                        //           displayHeight(context) * 0.6,
                                        //       width: displayWidth(context),
                                        //       child: Chewie(
                                        //         controller: ChewieController(
                                        //             videoPlayerController:
                                        //                 VideoPlayerController
                                        //                     .network(document[
                                        //                         "Picture"][0])
                                        //                   ..initialize()),
                                        //       ),
                                        //     ),
                                        //   ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 150.0),
                                                child: Center(
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        DocumentReference
                                                            postDoc =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "circles")
                                                                .doc(widget
                                                                    .churchID)
                                                                .collection(
                                                                    "posts")
                                                                .doc(widget
                                                                    .postID)
                                                                .collection(
                                                                    "comments")
                                                                .doc(document
                                                                    .id);
                                                        DocumentSnapshot post =
                                                            await postDoc.get();

                                                        List likedusers =
                                                            post["LikedBy"];
                                                        if (likedusers.contains(
                                                                widget.userID
                                                                    .toString()) ==
                                                            true) {
                                                          postDoc.update({
                                                            "LikedBy": FieldValue
                                                                .arrayRemove([
                                                              widget.userID
                                                            ])
                                                          });
                                                        } else {
                                                          postDoc.update({
                                                            "LikedBy": FieldValue
                                                                .arrayUnion([
                                                              widget.userID
                                                            ])
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.favorite,
                                                        color: document["LikedBy"]
                                                                    .contains(widget
                                                                        .userID) ==
                                                                true
                                                            ? Colors.red
                                                            : Colors.grey,
                                                      )),
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: getLikeCount(
                                                      document['LikedBy']),
                                                  style: const TextStyle(
                                                    color: BlackColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              if (widget.userID ==
                                                  document['ID'])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 120.0),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Confirm"),
                                                                content: const Text(
                                                                    "Are you sure you want to delete this post?"),
                                                                actions: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "Yes"),
                                                                    onPressed:
                                                                        () {
                                                                      deleteComment(
                                                                          widget
                                                                              .postID,
                                                                          widget
                                                                              .churchID,
                                                                          document
                                                                              .id);
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
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete)),
                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getLikeCount(document) {
    int likeCount = 0;
    var exMap;
    exMap = document;
    likeCount = exMap.length;
    return likeCount.toString();
  }
}

// ignore: unused_element
void _goToEditScreen(BuildContext context, String cID, String fName,
    String lName, String status, String textPost, String docID) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPost(
              circleID: cID,
              fName: fName,
              lName: lName,
              status: status,
              docID: docID,
              textField: textPost)));
}
