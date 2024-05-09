import 'package:flightsense/HomePage.dart';
import 'package:flightsense/Listview.dart';
//import 'package:flightsense/Map/Map.dart';
import 'package:flightsense/New_HomePage.dart';
import 'package:flightsense/RateReviewPage.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/chat/ChatPage.dart';
import 'package:flightsense/Payment.dart';
import 'package:flightsense/PendingPayments.dart';
import 'package:flightsense/firebase_options.dart';
import 'package:flightsense/newsfeed/newsFeed.dart';
import 'package:flightsense/newsfeed/sidebar.dart';
import 'package:flightsense/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:flightsense/RealTimeSearch/realtimeSearch.dart';
import 'package:flightsense/newsfeed/newsFeed.dart';
import 'package:flightsense/newsfeed/sidebar.dart';
// Import firebase_option.dart
// Import splashscreen.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: NewsFeed(),
    );
  }
}
