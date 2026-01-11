import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const OnboardingScreen() as Widget,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 31, 152, 252),
              Color.fromARGB(255, 135, 213, 250), 
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'images/splash.png',
            width: 2000,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
