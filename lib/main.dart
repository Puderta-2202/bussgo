import 'package:flutter/material.dart';
import 'package:bussgo/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusGO',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
