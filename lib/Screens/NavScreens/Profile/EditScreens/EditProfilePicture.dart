// ignore_for_file: prefer_const_constructors

import 'package:community/Screens/NavScreens/NavBar/NavBar.dart';
import 'package:community/storage/storage_services.dart';
import 'package:community/themes/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfilePicture extends StatefulWidget {
  const EditProfilePicture({Key? key}) : super(key: key);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    FutureBuilder(
        future: storage.listFiles(),
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshot.data!.items.length,
                itemBuilder: (BuildContext context, int index){
                  return ElevatedButton(onPressed: (() {
                    
                  }), child: Text(snapshot.data!.items[index].name));
                }),
              );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container();
        });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: PrimaryColor,
            ),
          ),
          title: const Text(
            "Edit Profile Details",
            style: TextStyle(color: BlackColor),
          ),
        ),

        // ignore: prefer_const_constructors
        body: TextButton(
          style: TextButton.styleFrom(
            primary: WhiteColor,
            backgroundColor: PrimaryColor,
            //padding: SignUpButtonPadding,
          ),
          child: Text("Update"),
          onPressed: () async {
            final results = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['png', 'jpg'],
            );

            if (results == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No File Selected')));
              return null;
            }

            final path = results.files.single.path!;
            final fileName = results.files.single.name;

            storage
                .uploadFile(path, fileName)
                .then((value) => print('Done Uploading File'));
          },
        ));
  }
}
