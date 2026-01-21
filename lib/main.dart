import 'package:flutter/material.dart';
import 'package:hotel_de_luna/onboarding.dart';
// import 'package:hotel_de_luna/splashscreen.dart';
// import 'package:hotel_de_luna/themedata.dart';
//import 'package:getwidget/getwidget.dart'; Use this for the custom widgets on any page!

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
