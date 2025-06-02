import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'forget_password.dart';
import 'app_color.dart';
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';

// --- Model Pengguna Sederhana ---
// class AppUser {
//   final String username;
//   final String password;
//   // Anda bisa menambahkan field lain seperti email, namaLengkap, dll.

//   AppUser({required this.username, required this.password});
// }
// // --- Akhir Model Pengguna ---

// // --- Daftar Pengguna Terdaftar (Simulasi Database) ---
// // Ini adalah list static tempat kita akan menyimpan pengguna yang mendaftar.
// // Di aplikasi nyata, ini akan digantikan oleh database.
// // Agar bisa diakses dari RegisterScreen, ini bisa dipindah ke file terpisah atau service.
// // Untuk contoh ini, kita letakkan di sini dulu.
// class UserDatabase {
//   // Wrapper class agar lebih terorganisir
//   static List<AppUser> registeredUsers = [
//     // Anda bisa menambahkan beberapa pengguna default untuk testing jika mau
//     AppUser(username: "user1", password: "password1"),
//   ];

//   static void addUser(AppUser user) {
//     registeredUsers.add(user);
//     print("User ditambahkan: ${user.username}"); // Untuk debug
//   }

//   static AppUser? findUser(String username, String password) {
//     try {
//       return registeredUsers.firstWhere(
//         (user) => user.username == username && user.password == password,
//       );
//     } catch (e) {
//       return null; // User tidak ditemukan
//     }
//   }
// }
// --- Akhir Daftar Pengguna ---

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Untuk toggle visibilitas password

  void _performLogin() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      AppUser? user = UserDatabase.findUser(username, password);

      if (user != null) {
        UserDatabase.loginUser(user); // Set pengguna yang sedang login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login berhasil! Selamat datang ${user.namaLengkap.isNotEmpty ? user.namaLengkap : user.username}',
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau password salah.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: mainBlue,
          ), // Latar belakang utama dari app_colors.dart
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height * 0.35,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/bis.jpg',
                                ), // Pastikan aset ini ada
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            child: CustomPaint(
                              size: Size(size.width, 40),
                              painter:
                                  BusContainerCurvePainter(), // Menggunakan mainBlue dari app_colors.dart
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
                              'Login', // Diubah dari 'Sign Up'
                              style: TextStyle(
                                fontSize: size.width * 0.055,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    'Maname', // Pastikan font ini ada di pubspec.yaml
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            Container(
                              // Username
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
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: size.width * 0.035,
                                    fontFamily: 'Mandali',
                                  ), // Pastikan font ini ada
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey[400],
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
                                    return 'Username tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            Container(
                              // Password
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
                                    // Tombol untuk show/hide password
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
                                  // Anda bisa menambahkan validasi panjang password jika perlu
                                  // if (value.length < 6) {
                                  //   return 'Password minimal 6 karakter';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            Container(
                              // Tombol Login
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
                                onPressed: _performLogin,
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
                              // Register & Forgot Password
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterScreen(),
                                      ),
                                    );
                                    if (result is String &&
                                        result.isNotEmpty &&
                                        mounted) {
                                      _usernameController.text =
                                          result; // Isi field username dengan hasil dari RegisterScreen
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Registrasi berhasil untuk $result. Silakan login.',
                                          ),
                                        ),
                                      );
                                    } else if (result == true && mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Registrasi berhasil. Silakan login.',
                                          ),
                                        ),
                                      );
                                    }
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

// CustomPainter untuk kurva di bawah gambar bis
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
