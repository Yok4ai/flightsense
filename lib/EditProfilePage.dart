import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String email;
  final VoidCallback refreshPage;

  EditProfilePage({required this.email, required this.refreshPage});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _instaController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _instaController = TextEditingController();

    // Fetch user data from Firestore and populate the text fields
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userData = userQuerySnapshot.docs.first.data();
        _nameController.text = userData['username'] ?? '';
        _dobController.text = userData['dateOfBirth'] ?? '';
        _phoneController.text = userData['phoneNumber'] ?? '';
        _instaController.text = userData['insta'] ?? '';
      } else {
        print('User document does not exist for email: ${widget.email}');
      }
    } catch (error) {
      print("Failed to fetch user data: $error");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _instaController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      // Ensure all text fields have non-null values before proceeding
      if (_nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _instaController.text.isNotEmpty) {
        // Update the user document matching the provided email
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.email)
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            // Update the first document found
            querySnapshot.docs.first.reference.update({
              'username': _nameController.text,
              'dateOfBirth': _dobController.text,
              'phoneNumber': _phoneController.text,
              'insta': _instaController.text,
            });
            Navigator.pop(context);
            widget.refreshPage();
          } else {
            print('User document does not exist for email: ${widget.email}');
          }
        });
      } else {
        print('One or more text fields are empty.');
      }
    } catch (error) {
      // Handle error
      print("Failed to update user profile: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blue, // Specify the desired color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _instaController,
              decoration: InputDecoration(labelText: 'Instagram Username'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

