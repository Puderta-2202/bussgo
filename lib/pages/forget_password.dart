import 'package:flutter/material.dart';
import 'home_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Kata Sandi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF1A8AEA),
      ),
      body: Container(
        color: Color(0xFFBAE1F9),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0),
                        // Description text
                        Text(
                          'MASUKKAN KATA SANDI LAMA & BARU ANDA UNTUK MENGGANTI KATA SANDI',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Maname',
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Input: Kata Sandi Lama
                        _buildTextField('Kata Sandi Lama', size, _obscureText1),

                        // Input: Kata Sandi Baru
                        _buildTextField('Kata Sandi Baru', size, _obscureText2),

                        // Input: Ulang Kata Sandi Baru
                        _buildTextField(
                          'Ulang Kata Sandi Baru',
                          size,
                          _obscureText3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Perbarui button at the bottom
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.05),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Show dialog to notify the user that password has been updated
                      _showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A8AEA),
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                        horizontal: size.width * 0.25,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Perbarui',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: size.width * 0.045,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each TextField with password visibility toggle
  Widget _buildTextField(String label, Size size, bool obscureText) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.03),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.black87,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                if (label == 'Kata Sandi Lama') {
                  _obscureText1 = !_obscureText1;
                } else if (label == 'Kata Sandi Baru') {
                  _obscureText2 = !_obscureText2;
                } else if (label == 'Ulang Kata Sandi Baru') {
                  _obscureText3 = !_obscureText3;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  // Show Success Dialog and navigate to HomeScreen when OK is clicked
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kata Sandi Diperbarui'),
          content: Text('Kata sandi Anda telah berhasil diperbarui.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ), // Navigate to HomeScreen
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
