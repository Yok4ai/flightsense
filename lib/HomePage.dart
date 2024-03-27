import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Add Key parameter

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed In as: ${user.email!}'),
            MaterialButton(
              onPressed: () {
                // Sign out
                FirebaseAuth.instance.signOut();

                // Navigate to UserProfilePage with specified parameters
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      profileImageUrl: 'assets/images/gojo.png',
                      name: 'Shuvo',
                      phoneNumber: '01866946299',
                      email: 'shuvo.sss1906@gmail.com',
                      instagramUsername: '__Shruv',
                      dateOfBirth: '19/06/2000',
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
