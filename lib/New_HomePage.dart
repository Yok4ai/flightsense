import 'package:flutter/material.dart';

class MyNewHomepage extends StatefulWidget {
  const MyNewHomepage({super.key});

  @override
  State<MyNewHomepage> createState() => _MyNewHomepageState();
}

class _MyNewHomepageState extends State<MyNewHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[200],
      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
               decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 300,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Container 1',style: TextStyle(fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
               decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 500,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Container 2',style: TextStyle(fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                    ),
                  ),
            ),
          ),
        ],
      ),
      
    );
  }
}