import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/GroupChat.dart';
import 'package:flightsense/HTTPRequest.dart';
import 'package:flightsense/newsfeed/newsFeed.dart';
import 'package:flutter/material.dart';
import 'package:flightsense/RealTimeSearch/realtimeSearch.dart';
import 'package:flightsense/BookingHistory.dart';
import 'package:flightsense/CSV2.dart';
import 'package:flightsense/PendingPayments.dart';
import 'package:flightsense/ReviewsShow.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/chat/ChatPage.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/Map.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsFeed()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage(profileImageUrl: '123', name: 'name', dateOfBirth: 'dateOfBirth',
                  phoneNumber: 'phoneNumber', instagramUsername: 'instagramUsername', email: 'email')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RealtimeSearchPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapSample()),
              );
            },
          ),
           ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Group Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupChatPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flight),
            title: const Text('Flight'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CSVFlight()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Reviews'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewShowPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PendingPayments()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Price Prediction'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PriceDisplay()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
