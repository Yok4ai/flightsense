//import 'package:flightsense/Map/Map.dart';
import 'package:flightsense/HTTPRequest.dart';
import 'package:flightsense/HomePage.dart';
import 'package:flightsense/PredictPage.dart';
import 'package:flightsense/firebase_options.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/newsfeed/location.dart';
import 'package:flightsense/newsfeed/newsFeed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
// Import firebase_option.dart
// Import splashscreen.dart
//commit
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
      home: PriceDisplayPage(),
    );
  }
}
