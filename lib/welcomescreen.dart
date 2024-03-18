// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/regscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: 
              Color.fromARGB(255, 103, 57, 229)
          ),
        child: Column(children: [
        
              Image(image: AssetImage('assets/images/planewhite.png')),
              SizedBox(height: 10),
              Text('Welcome',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              child: Container(
                height: 50,
                width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white,width: 2),
                    ),
                    child: Center(child: Text('SIGN IN',style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
                  ),
              ),
              
              SizedBox(height: 20),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white,width: 2),
                      ),
                      child: Center(child: Text('SIGN UP',style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)))),
                    ),
              ),
              
        
        ]
        ),
      ),
    );
  }
}
