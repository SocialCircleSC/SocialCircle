import 'dart:io';

import 'package:community/firestore/update_profile.dart';
import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userID;
  final String email;
  final String profilePic;

  const EditProfile(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.userID,
      required this.email,
      required this.profilePic});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isObscure = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  var imagePath = [];
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
          backgroundColor: WhiteColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: PrimaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  color: PrimaryColor,
                ))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      if (imagePath.isEmpty)
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: WhiteColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.profilePic))),
                        ),
                      if (imagePath.isNotEmpty)
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: WhiteColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(imagePath[0])))),
                        ),
                      GestureDetector(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            imagePath.add(file!.path);
                          });
                        },
                        child: Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: WhiteColor,
                                ),
                                color: PrimaryColor,
                              ),
                              child: const Icon(Icons.edit, color: BlackColor),
                            )),
                      )
                    ],
                  ),
                ),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: widget.firstName,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: BlackColor,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: widget.lastName,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: BlackColor,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: widget.email,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: BlackColor,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: !_isObscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Change Password",
                    labelStyle: const TextStyle(
                        color: TextFieldColor, fontWeight: FontWeight.w400),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: PrimaryColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: WhiteColor,
                    backgroundColor: PrimaryColor,
                    padding: SignUpButtonPadding,
                  ),
                  child: const Text("Update"),
                  onPressed: () {
                    updateProfile(
                        widget.userID,
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        imagePath[0]);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
