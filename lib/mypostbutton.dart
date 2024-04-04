import 'package:flutter/material.dart';

class MyPostButton extends StatelessWidget {
  final void Function()? ontap;
  const MyPostButton({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 10),
        child: Center(
          child: Icon(Icons.done, color: Colors.white,),
        ),
      ),
    );
  }
}