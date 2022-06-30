// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class cardData extends StatefulWidget {
  const cardData({Key? key}) : super(key: key);

  @override
  State<cardData> createState() => _cardDataState();
}

class _cardDataState extends State<cardData> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            //Padding(padding: EdgeInsets.all(5)),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/fp_profile.jpg'),
              ),
              title: Text(
                'Olaoluwa Olojede',
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Member',
                style: TextStyle(fontSize: 13.0),
              ),
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10)),
                Flexible(
                  child: Text(
                    "Good afternoon church! Thank you so much for being with us! See you all next week!",
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                //Padding(padding: EdgeInsets.symmetric(vertical: 60)),
                Expanded(
                  child: Image.network(
                    'https://googleflutter.com/sample_image.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                SizedBox(
                  width: 25,
                ),
                LikeButton(
                  size: 20,
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: SecondaryColor,
                    dotSecondaryColor: SecondaryColor,
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.thumb_up,
                      color: isLiked ? PrimaryColor : Colors.blueGrey,
                      size: 20,
                    );
                  },
                  likeCount: 665,
                  countBuilder: (count, bool isLiked, String text) {
                    var color = isLiked ? PrimaryColor : Colors.blueGrey;
                    Widget result;
                    if (count == 0) {
                      result = Text(
                        "love",
                        style: TextStyle(color: color),
                      );
                    } else {
                      result = Text(
                        text,
                        style: TextStyle(color: color),
                      );
                    }
                    return result;
                  },
                ),
                SizedBox(
                  width: 70,
                ),
                Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.comment,
                          color: Colors.blueGrey,
                        ),
                        label: const Text(
                          "Comment",
                          style: TextStyle(color: Colors.blueGrey),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
