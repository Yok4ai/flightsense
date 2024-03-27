import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExtractUsername extends StatefulWidget {
  @override
  _ExtractUsernameState createState() => _ExtractUsernameState();
}

class _ExtractUsernameState extends State<ExtractUsername> {
  TextEditingController _emailController = TextEditingController();
  String _username = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Username'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  _fetchUsername(email);
                } else {
                  setState(() {
                    _username = 'Please enter an email.';
                  });
                }
              },
              child: Text('Fetch Username'),
            ),
            SizedBox(height: 20.0),
            if (_username.isNotEmpty)
              Text(
                'Username: $_username',
                style: TextStyle(fontSize: 18.0),
              ),
          ],
        ),
      ),
    );
  }
}
