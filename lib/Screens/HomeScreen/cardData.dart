// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class cardData extends StatelessWidget {
  const cardData({Key? key}) : super(key: key);

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
                        'https://googleflutter.com/sample_image.jpg')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
