import 'package:attendanceApp/pages/splash/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        dialogBackgroundColor: Colors.transparent,
        hintColor: Colors.white70.withOpacity(0.6),
      ),
      home: SplashScreen(),
    );
  }
}


