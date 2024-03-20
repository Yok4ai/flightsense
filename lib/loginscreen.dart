// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/ForgetPasswordPage.dart';
import 'package:flightsense/HomePage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This widget is the root of your application.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
      // Sign-in successful, navigate or perform other actions
      print("Sign-in successful!"); // Or navigate to a home screen
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Show a snackbar or dialog to the user with this message
        _showErrorDialog("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
        // Show a snackbar or dialog to the user with this message
        _showErrorDialog("Wrong password provided for that email.");
      } else {
        print(e.code); // Print the error code for debugging
        // Handle other potential errors
        _showErrorDialog("An error occurred. Please try again.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 103, 57, 229)),
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 19),
            child: Text(
              "Hello\nSign in!",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      label: Text(
                        "Email",
                        style: TextStyle(
                            color: Color.fromARGB(255, 103, 57, 229),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      // hintText: "Email",
                    )),
                TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      label: Text(
                        "Password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 103, 57, 229),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      // hintText: "Password",
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgetPasswordPage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Color.fromARGB(255, 103, 57, 229),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 103, 57, 229),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
