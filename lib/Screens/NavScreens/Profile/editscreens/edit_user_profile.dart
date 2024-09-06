import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/Screens/authscreens/signup/church_sub.dart';
import 'package:socialorb/firestore/deleteChurch.dart';
import 'package:socialorb/firestore/deleteMemberAccount.dart';
import 'package:socialorb/firestore/getChurchID.dart';
import 'package:socialorb/firestore/update_profile.dart';
import 'package:socialorb/main.dart';
import 'package:socialorb/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userID;
  final String email;
  final String profilePic;
  final String churchID;

  const EditProfile(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.userID,
      required this.email,
      required this.profilePic, required this.churchID});

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

  bool cond = false;

  @override
  Widget build(BuildContext context) {
    if (widget.userID == widget.churchID){
      cond = true;
    }

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
            cond ? IconButtonWithDropdownC(vID: widget.churchID,) : IconButtonWithDropdown(value: widget.churchID),
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
                  onPressed: () async {
                    updateProfile(
                        widget.userID,
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        imagePath);
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


//For users

class IconButtonWithDropdown extends StatefulWidget {
  late final String value;

  // Accept value via constructor
  IconButtonWithDropdown({required this.value});

  @override
  IconButtonWithDropdownUser createState() => IconButtonWithDropdownUser(churchValue: value);
}

class IconButtonWithDropdownUser extends State<IconButtonWithDropdown> {
    late final String churchValue;

  // Accept value via constructor
  IconButtonWithDropdownUser({required this.churchValue});
  @override
  Widget build(BuildContext context) {
    bool check = false;
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: PrimaryColor,), // The icon for the button
      onSelected: (String result) {
        if(result == 'Delete Account'){
          verifyDialog(context, churchValue);
        }
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>
      [
        
        const PopupMenuItem<String>(
          value: 'Delete Account',
          child: Text('Delete Account'),
        ),
        
      ],
    );
  }

    // Function to show the alert dialog
  Future<void> verifyDialog(BuildContext context, valueID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete your account?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This action is permanent and will delete all information you have store in this account'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),

            TextButton(
              child: const Text('Yes'),
              onPressed: () async{
                //Delete Account from Firebase Auththenication
                User? user = FirebaseAuth.instance.currentUser;
                await user!.delete();

                

                //Delete from Cloud Firestore
                await deleteMember(user.uid, valueID);

                //Sign out
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainPage()));
                Fluttertoast.showToast(msg: "Account Deleted");
              },
            ),
          ],
        );
      },
    );
  }
}

// For churches

class IconButtonWithDropdownC extends StatefulWidget {
  late final String vID; 

    // Accept value via constructor
  IconButtonWithDropdownC({required this.vID});

  @override
  IconButtonWithDropdownChurch createState() => IconButtonWithDropdownChurch(churchValue: vID);
}

class IconButtonWithDropdownChurch extends State<IconButtonWithDropdownC> {
  late final String churchValue;

  // Accept value via constructor
  IconButtonWithDropdownChurch({required this.churchValue});
  @override
  Widget build(BuildContext context) {
    bool check = false;
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: PrimaryColor,), // The icon for the button
      onSelected: (String result) async {
        if(result == 'Delete Account') {
          await deleteChurch(widget.vID);
            Fluttertoast.showToast(
              msg: "Your account will be deleted in 2-3 business days.",
              toastLength: Toast.LENGTH_LONG,  // Show toast for a longer duration
              gravity: ToastGravity.BOTTOM,     // Position the toast at the bottom of the screen
              fontSize: 16.0,                   // Font size
            );
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChurchSub(churchID: widget.vID,)),
            );
        }
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>
      [
        
        const PopupMenuItem<String>(
          value: 'Delete Account',
          child: Text('Delete Account'),
        ),

        const PopupMenuItem<String>(
          value: 'Edit Subscription',
          child: Text('Edit Subscription'),
        ),
        
      ],
    );
  }

}