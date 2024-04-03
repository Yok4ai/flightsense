import "package:flutter/material.dart";

class Listsquare extends StatelessWidget {
  final String child;

  const Listsquare({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.only(top: 40, right: 25, left: 25),
            child: Container(
              decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(child,style: const TextStyle(fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
                ),
              ),

            ),
          );
  }
}