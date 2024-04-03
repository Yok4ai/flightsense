import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class New_HomePage extends StatefulWidget {
  const New_HomePage({Key? key}) : super(key: key);

  @override
  _New_HomePageState createState() => _New_HomePageState();
}

class _New_HomePageState extends State<New_HomePage> {
  late Future<String> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _fetchUsername();
  }

  Future<String> _fetchUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          return data['username'];
        } else {
          return 'User not found';
        }
      } else {
        return 'User not logged in';
      }
    } catch (e) {
      return 'Error fetching username: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0), // Set the preferred height
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(255, 103, 57, 229)),
          child: Padding(
            padding: EdgeInsets.only(top: 1, left: 19,right: 19),
                 child: Row(
                           children: [
                             IconButton(
                               onPressed: () {
                                 // Handle menu button click
                               },
                               icon: Icon(Icons.menu),
                             ),
                             Spacer(),
                             FutureBuilder<String>(
                               future: _usernameFuture,
                               builder: (context, snapshot) {
                                 if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                                 } else if (snapshot.hasData) {
                  return Row(
                    children: [
                      Text(
                        'Hi, ${snapshot.data}',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/gojo.png'),
                      ),
                    ],
                  );
                                 } else {
                  return Text('Error fetching username');
                                 }
                               },
                             ),
                           ],
                         ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('From', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Destination', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Date', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              onTap: () {
                // Handle date selection
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle search flight button click
              },
              child: Text('Search Flights'),
            ),
          ],
        ),
      ),
    );
  }
}

