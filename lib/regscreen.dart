// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _userController = TextEditingController();

  bool PasswordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future signUP() async {
    if (PasswordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
         _showErrorDialog("SignUP is Successfull, You can SignIn now");
         await Future.delayed(const Duration(seconds: 2));
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
      } on FirebaseAuthException catch (e) {
       if (e.code == 'email-already-in-use') {
          print('The email address is already in use by another account.');
          // Show a error dialogue.
          _showErrorDialog('The email address is already in use by another account.');
        } else if(e.code=='weak-password'){
          print('__password is too short__'); // Print the error code for debugging
          // Handle other potential errors
          _showErrorDialog('__password is too short__');
        }else {
          print(e.code); // Print the error code for debugging
          // Handle other potential errors
          _showErrorDialog('Registration failed. Please try again.');
        }
      }
    } else {
        _showErrorDialog('Password did not matched');
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
    _confirmpasswordController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 103, 57, 229)),
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 19),
                child: Text(
                  "Create\nYour Account",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                        controller: _userController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "Username",
                            style: TextStyle(
                                color: Color.fromARGB(255, 103, 57, 229),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          // hintText: "Email",
                        )),
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
                    TextField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "Confirm Password",
                            style: TextStyle(
                                color: Color.fromARGB(255, 103, 57, 229),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          // hintText: "Email",
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUP();
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 103, 57, 229),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
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
