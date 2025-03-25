// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialorb/firestore/addChurchMemList.dart';
import 'package:socialorb/firestore/memberSignUpData.dart';
import 'package:socialorb/screens/authscreens/login/login_screen.dart';
import 'package:socialorb/sizes/size.dart';
import 'package:socialorb/themes/theme.dart';

class Church {
  final String id;
  final String name;
  final String address;

  Church({required this.id, required this.name, required this.address});

  factory Church.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Church(
      id: doc.id,
      name: data['First Name'] ?? 'Unknown Church',
      address: data['Street Address'] ?? 'No address provided',
    );
  }
}

class ChooseChurch extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool guest;

  const ChooseChurch({
    Key? key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.guest,
  }) : super(key: key);

  @override
  State<ChooseChurch> createState() => _ChooseChurchState();
}

class _ChooseChurchState extends State<ChooseChurch> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Using a single list of Church objects instead of multiple synced lists
  List<Church> _allChurches = [];
  List<Church> _filteredChurches = [];

  @override
  void initState() {
    super.initState();
    _fetchChurches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchChurches() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('circles')
          .orderBy('First Name')
          .get();

      final churches = querySnapshot.docs.map((doc) => Church.fromFirestore(doc)).toList();
      
      setState(() {
        _allChurches = churches;
        _filteredChurches = churches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load churches: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('Error fetching churches: $e');
    }
  }

  void _filterChurches(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredChurches = _allChurches;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredChurches = _allChurches
          .where((church) => church.name.toLowerCase().contains(lowercaseQuery))
          .toList();
    });
  }

  Future<void> _selectChurch(Church church) async {
    try {
      // Creating user account
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: widget.password);

      final user = userCredential.user;
      if (user != null) {
        // Update user profile with church data
        await userSetup(
          widget.firstName,
          widget.lastName,
          widget.email,
          church.name,
          church.id,
        );

        // Update user document with church info
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'Church Name': church.name,
          'Church ID': church.id,
        });

        // Add user to church member list
        await addChurchMemberList(
          church.id,
          widget.email,
          widget.firstName,
          widget.lastName,
        );

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        Fluttertoast.showToast(
          msg: "Your account has been created. Please login to use the app",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'weak-password':
          errorMessage = "The password is too weak, please go back and change the password";
          break;
        case 'email-already-in-use':
          errorMessage = "Email already exists, please go back and change the email";
          break;
        default:
          errorMessage = "An error occurred: ${e.message}";
      }
      
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred. Please try again.",
        toastLength: Toast.LENGTH_LONG,
      );
      debugPrint('Error selecting church: $e');
    }
  }

  void _showConfirmationDialog(Church church) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to pick ${church.name} as your church?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                _selectChurch(church);
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The System Back Button is Deactivated')),
        );
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
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: WhiteColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.01),
              TextField(
                controller: _searchController,
                onChanged: _filterChurches,
                decoration: InputDecoration(
                  labelText: 'Search for a church',
                  hintText: 'Enter church name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredChurches.isEmpty
                        ? Center(
                            child: Text(
                              'No churches found',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredChurches.length,
                            itemBuilder: (context, index) {
                              final church = _filteredChurches[index];
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    church.name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(church.address),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  onTap: () => _showConfirmationDialog(church),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}