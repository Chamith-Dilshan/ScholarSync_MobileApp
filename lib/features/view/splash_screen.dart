import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required StreamBuilder<User?> child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }
  _navigatetohome() async {
  await Future.delayed(const Duration(milliseconds: 2500));
  if (mounted) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LogInPage())
    );
  }
}

  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 124, 17),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/splash_image.png',
                width: 160,
                height: 160,
              ),
              const Text(
                'ScholarSync',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}