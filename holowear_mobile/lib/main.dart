import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HoloWearApp());
}

class HoloWearApp extends StatelessWidget {
  const HoloWearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoloWear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}