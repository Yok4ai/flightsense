import 'package:flutter/material.dart';
import 'package:flightsense/Listsquare.dart';

class MyListView extends StatelessWidget {
  final List _posts=[
    'From: Aus\nTo: NZ\nDep:12/04/2024\nPrice: \$60',
    'post 2',
    'post 3',
    'post 4',
    'post 5',
    'post 6',
    'post 7',
    'post 8',
    'post 9',
    'post 10',
  ];

  MyListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 21, 27),
      body: ListView.builder(
         itemCount: _posts.length,
         itemBuilder: (context,index){
          return Listsquare(child: _posts[index],); 
         },
      ),
    );
  }
}
