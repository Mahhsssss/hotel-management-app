import 'package:flutter/material.dart';
import 'package:hotel_de_luna/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
