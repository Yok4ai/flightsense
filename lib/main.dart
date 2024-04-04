import 'package:flightsense/CSV.dart';
import 'package:flightsense/CSVRead.dart';
import 'package:flightsense/HomePage.dart';
import 'package:flightsense/Listview.dart';
import 'package:flightsense/New_HomePage.dart';
import 'package:flightsense/Threads.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/firebase_options.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/regscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
// Import firebase_option.dart
import 'splashscreen.dart'; // Import splashscreen.dart
import 'CSVRead.dart';
import 'CSV.dart';
import 'CSV2.dart';

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
      home: CSVFlight(),
    );
  }
}
