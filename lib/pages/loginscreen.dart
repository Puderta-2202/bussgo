import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'forget_password.dart';
import 'app_color.dart';

// const Color mainBlue = Color(0xFF1A9AEB);

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background utama
          Container(color: mainBlue),

          // Konten scroll
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: size.height * 0.35,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bis.jpg'),
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          child: CustomPaint(
                            size: Size(size.width, 40),
                            painter: BusContainerCurvePainter(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.all(size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Maname',
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Username
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: size.width * 0.035,
                                  fontFamily: 'Mandali',
                                ),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.015),

                          // Password
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: size.width * 0.035,
                                  fontFamily: 'Mandali',
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.025),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [mainBlue, mainBlue],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.018,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Maname',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.015),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigasi ke halaman Register saat "Register" diklik
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ), // Ganti RegisterScreen dengan halaman register yang sesuai
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Maname',
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.015),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.005,
                                ),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.015),
                              GestureDetector(
                                onTap: () {
                                  // Navigasi ke halaman Forgot Password saat "Forgot Password" diklik
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgetPasswordScreen(),
                                    ), // Ganti ForgotPasswordScreen dengan halaman yang sesuai
                                  );
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Maname',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.1), // Tambahan spacer
                  ],
                ),
              ),
            ),
          ),

          // Wave di bawah layar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, 80),
              painter: BottomWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class BusContainerCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = mainBlue
          ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.7,
      size.height * -0.8,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFB3E5FC)
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.2,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
