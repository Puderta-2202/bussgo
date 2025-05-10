import 'package:flutter/material.dart';
import 'loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText1 = true; // Password field 1
  bool _obscureText2 = true; // Password field 2

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background color set to #1A8AEA
          Container(
            color: Color(0xFF1A8AEA), // Set background color to #1A8AEA
          ),
          // Bottom curve
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height:
                    size.height *
                    0.15, // Adjust the curve height proportionally
                color: Colors.lightBlue.shade50,
              ),
            ),
          ),
          // Padding around the entire form container
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.05, // 5% from the top
              bottom: size.height * 0.15, // 15% from the bottom
            ),
            child: Center(
              child: Container(
                width:
                    size.width *
                    0.85, // Make the form responsive to screen width
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Register Form',
                      style: TextStyle(
                        fontSize:
                            size.width *
                            0.065, // Font size responsive to screen width
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Nama Lengkap', size),
                    _buildTextField('Email', size),
                    _buildTextField('No Handphone', size),
                    _buildTextField('Username', size),
                    _buildTextField(
                      'Password',
                      size,
                      obscureText: _obscureText1,
                    ),
                    _buildTextField(
                      'Konfirmasi Password',
                      size,
                      obscureText: _obscureText2,
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _showRegistrationSuccessDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            vertical:
                                size.height * 0.02, // Proportional padding
                            horizontal:
                                size.width * 0.25, // Proportional padding
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                          ), // Responsive font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each text field with responsive sizing
  Widget _buildTextField(String label, Size size, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.black87,
          ), // Responsive font size for label
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Function to show the registration success dialog
  void _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pendaftaran Berhasil"),
          content: Text("Akun Anda telah berhasil didaftarkan."),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to Login page after closing the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

// Custom clipper untuk bagian bawah yang melengkung
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5, // Increase the curve for more height
      size.width * 0.5,
      size.height * 0.5, // Increase the curve for more height
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.5, // Increase the curve for more height
      size.width,
      size.height * 0.2, // Lower the end point to create a sharp curve
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path; // Return the path instead of painting
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
