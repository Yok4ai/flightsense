import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flightsense/RealTimeSearch/realtimeSearch.dart';
import 'package:flightsense/BookingHistory.dart';
import 'package:flightsense/CSV2.dart';
import 'package:flightsense/Payment.dart';
import 'package:flightsense/PendingPayments.dart';
import 'package:flightsense/ReviewsShow.dart';
import 'package:flightsense/SearchPage.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/chat/ChatPage.dart';
import 'package:flightsense/loginscreen.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'FlightSense',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage(profileImageUrl: '123', name: 'name', dateOfBirth: 'dateOfBirth',
                  phoneNumber: 'phoneNumber', instagramUsername: 'instagramUsername', email: 'email')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RealtimeSearchPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.flight),
            title: Text('Flight'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CSVFlight()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Reviews'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewShowPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingPayments()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
