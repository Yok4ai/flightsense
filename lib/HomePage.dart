import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/UserProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Add Key parameter

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {}); // Trigger a rebuild after fetching the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null && _user!.email != null) // Add null check for email
              Text('Signed In as: ${_user!.email}'), // Remove the null check for email here
            MaterialButton(
              onPressed: () async {
                // Sign out
                await FirebaseAuth.instance.signOut();

                // Navigate to UserProfilePage with specified parameters
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      profileImageUrl: 'assets/images/gojo.png',
                      name: 'Shuvo',
                      phoneNumber: '01866946299',
                      // email: 'N/A',
                      instagramUsername: '__Shruv',
                      dateOfBirth: '19/06/2000', 
                      email: _user?.email ?? '',
                    ),
                  ),
                );
              },
              color: Colors.blue,
              child: const Text('User Profile'),
            )
          ],
        ),
      ),
    );
  }
}
