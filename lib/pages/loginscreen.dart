import 'package:bussgo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'forget_password.dart';
import 'app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // Ganti _usernameController menjadi _emailController untuk sinkron dengan API
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false; // State untuk loading

  final _storage = const FlutterSecureStorage(); // Inisialisasi secure storage

  void _performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mulai loading
      });

      try {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        // Panggil service API kita, bukan UserDatabase lagi
        final response = await AuthService.login(email, password);

        // Simpan token dengan aman
        await _storage.write(
          key: 'auth_token',
          value: response['access_token'],
        );

        if (mounted) {
          // Pastikan widget masih ada di tree
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        // Tampilkan pesan error dari API atau koneksi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hentikan loading
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ... (UI Latar Belakang dan Gambar Anda tetap sama) ...
          Container(color: mainBlue),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ... (Stack Gambar Bus Anda tetap sama) ...
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
                              'Login',
                              style: TextStyle(
                                fontSize: size.width * 0.055,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Maname',
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            // --- PERUBAHAN PADA INPUT EMAIL ---
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
                              child: TextFormField(
                                controller:
                                    _emailController, // Ganti controller
                                keyboardType:
                                    TextInputType
                                        .emailAddress, // Ganti keyboard type
                                decoration: InputDecoration(
                                  hintText: 'Email', // Ganti hint text
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: size.width * 0.035,
                                    fontFamily: 'Mandali',
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey[400],
                                  ), // Ganti ikon
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.018,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!RegExp(
                                    r'\S+@\S+\.\S+',
                                  ).hasMatch(value)) {
                                    // Validasi email sederhana
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            // --- INPUT PASSWORD TETAP SAMA ---
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
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.018,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            // --- PERUBAHAN PADA TOMBOL LOGIN ---
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
                                onPressed:
                                    _isLoading
                                        ? null
                                        : _performLogin, // Nonaktifkan tombol saat loading
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
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          // Tampilkan loading indicator
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                        : Text(
                                          // Tampilkan teks "Login"
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
                            // ... (Sisa UI Anda tetap sama) ...
                            SizedBox(height: size.height * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterScreen(),
                                      ),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ForgetPasswordScreen(),
                                      ),
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
                      SizedBox(height: size.height * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ... (UI Bottom Wave Painter Anda tetap sama) ...
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

// ... (Kode CustomPainter Anda tetap sama) ...
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
