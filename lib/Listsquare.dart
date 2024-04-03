import "package:flutter/material.dart";

class Listsquare extends StatelessWidget {
  final String child;

  Listsquare({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
            child: Container(
              decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(child,style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
              ),

            ),
          );
  }
}