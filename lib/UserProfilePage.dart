import 'package:flutter/material.dart';
import 'EditProfilePage.dart';

class UserProfilePage extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String dateOfBirth;
  final String phoneNumber;
  final String instagramUsername;
  final String email;

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
  String _name = '';
  String _dateOfBirth = '';
  String _phoneNumber = '';
  String _instagramUsername = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _dateOfBirth = widget.dateOfBirth;
    _phoneNumber = widget.phoneNumber;
    _instagramUsername = widget.instagramUsername;
    _email = widget.email;
  }

  void _updateUserProfile({
    required String name,
    required String dateOfBirth,
    required String phoneNumber,
    required String instagramUsername,
    required String email,
  }) {
    setState(() {
      _name = name;
      _dateOfBirth = dateOfBirth;
      _phoneNumber = phoneNumber;
      _instagramUsername = instagramUsername;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _name,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              _buildUserInfoRow(Icons.cake, 'Date of Birth:', _dateOfBirth),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.phone, 'Phone Number:', _phoneNumber),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.account_box_outlined, 'Instagram:', _instagramUsername),
              SizedBox(height: 12.0),
              _buildUserInfoRow(Icons.email, 'Email:', _email),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage(
                      name: _name,
                      dateOfBirth: _dateOfBirth,
                      phoneNumber: _phoneNumber,
                      instagramUsername: _instagramUsername,
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