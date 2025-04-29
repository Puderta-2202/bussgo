import 'package:flutter/material.dart';
import 'package:bussgo/pages/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1EA1F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo di dalam lingkaran putih
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/images/bis3.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'BusGO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kadwa',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
