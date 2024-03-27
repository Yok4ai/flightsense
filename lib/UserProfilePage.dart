import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditProfilePage.dart';

class UserProfilePage extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String dateOfBirth;
  final String phoneNumber;
  final String instagramUsername;
  final String email; // Include email field in the constructor

  UserProfilePage({
    required this.profileImageUrl,
    required this.name,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.instagramUsername,
    required this.email,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
<<<<<<< HEAD
  late String _email;
  late String _username= '';
  late String _instaname= '';
=======
  late String _email = '';
  late String _username = '';
>>>>>>> 9c86de62d728e7b0ae3d2f350d7388ae53f2bbcb

  @override
  void initState() {
    super.initState();
    _email = widget.email; // Initialize with the provided email
<<<<<<< HEAD
    _fetchUserEmail(); // Fetch the user's email
    _fetchUsername(_email);
    _fetchUserinsta(_email);
=======
    _fetchUserData(); // Fetch the user's data including username
  }

  Future<void> _fetchUserData() async {
    await _fetchUserEmail(); // Fetch the user's email
    await _fetchUsername(_email); // Fetch the user's username
>>>>>>> 9c86de62d728e7b0ae3d2f350d7388ae53f2bbcb
  }

  Future<void> _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      setState(() {
        _email = user.email!; // Update _email if the user's email is not null
      });
    }
  }

  Future<void> _fetchUsername(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _username = data['username'];
        });
      } else {
        setState(() {
          _username = 'User with email $email not found.';
        });
      }
    } catch (e) {
      setState(() {
        _username = 'Error fetching username: $e';
      });
    }
  }

<<<<<<< HEAD
   Future<void> _fetchUserinsta(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _instaname = data['insta'];
        });
      } else {
        setState(() {
          _instaname = 'User with email $email not found.';
        });
      }
    } catch (e) {
      setState(() {
        _instaname = 'Error fetching insta: $e';
      });
    }
  }

=======
>>>>>>> 9c86de62d728e7b0ae3d2f350d7388ae53f2bbcb
  void _updateUserProfile({
    required String name,
    required String dateOfBirth,
    required String phoneNumber,
    required String instagramUsername,
    required String email,
  }) {
    setState(() {
      // Update the state variables
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_email.isEmpty || _username.isEmpty) {
      // If email or username is empty, show a loading indicator or handle it accordingly
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage(widget.profileImageUrl),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                _username,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              _buildUserInfoRow(Icons.cake, 'Date of Birth:', widget.dateOfBirth),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.phone, 'Phone Number:', widget.phoneNumber),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.account_box_outlined, 'Instagram:', _instaname),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.email, 'Email:', _email),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage(
                      name: _username,
                      dateOfBirth: widget.dateOfBirth,
                      phoneNumber: widget.phoneNumber,
                      instagramUsername: _instaname,
                      email: _email,
                      onUpdateProfile: _updateUserProfile,
                    )),
                  );
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 20.0),
          SizedBox(width: 16.0),
          Text(
            label,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(width: 16.0),
          Text(
            value,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
