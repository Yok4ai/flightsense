import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController instagramUsernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Function onUpdateProfile;

  EditProfilePage({
    required String name,
    required String dateOfBirth,
    required String phoneNumber,
    required String instagramUsername,
    required String email,
    required this.onUpdateProfile,
  }) {
    nameController.text = name;
    dateOfBirthController.text = dateOfBirth;
    phoneNumberController.text = phoneNumber;
    instagramUsernameController.text = instagramUsername;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blue, // Specify the desired color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: dateOfBirthController,
              decoration:                   InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: instagramUsernameController,
              decoration: InputDecoration(labelText: 'Instagram Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                onUpdateProfile(
                  name: nameController.text,
                  dateOfBirth: dateOfBirthController.text,
                  phoneNumber: phoneNumberController.text,
                  instagramUsername: instagramUsernameController.text,
                  email: emailController.text,
                );
                // Save changes and navigate back to UserProfilePage
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

