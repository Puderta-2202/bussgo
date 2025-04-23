import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1EA1F1), // Warna biru sesuai gambar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar bus
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
