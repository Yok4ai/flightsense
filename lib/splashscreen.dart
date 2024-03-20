// this is a splashscreen
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flightsense/welcomescreen.dart';
import 'package:page_transition/page_transition.dart';

class splashscreen extends StatelessWidget{
  const splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
               ///TODO Add your image under assets folder
             Image.asset('assets/images/planewhite.png'),
            const Text('Flight Sense', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),)
           ],
         ),
        backgroundColor: const Color.fromARGB(255, 108, 85, 255),
        nextScreen: const WelcomeScreen(),
      splashIconSize: 700,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      animationDuration: const Duration(seconds: 2),
    );
  }
}