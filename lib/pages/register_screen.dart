import 'package:flutter/material.dart';
// import 'loginscreen.dart';
import 'app_color.dart';
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _performRegister() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      String namaLengkap = _namaLengkapController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text;
      String email = _emailController.text.trim(); // Jika ingin disimpan
      String noHp = _noHpController.text.trim(); // Jika ingin disimpan

      AppUser newUser = AppUser(
        username: username,
        password: password,
        namaLengkap: namaLengkap,
        email: email, // Tambahkan ke model AppUser jika perlu
        noHandphone: noHp, // Tambahkan ke model AppUser jika perlu
      );

      bool isAdded = UserDatabase.addUser(newUser);

      if (isAdded) {
        _showRegistrationSuccessDialog(context, username, namaLengkap);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[600],
            content: Text(
              'Username "$username" sudah digunakan. Silakan pilih username lain.',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Harap isi semua field yang wajib dengan benar.'),
        ),
      );
    }
  }

  void _showRegistrationSuccessDialog(
    BuildContext context,
    String username,
    String namaLengkap,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Pendaftaran Berhasil"),
            ],
          ),
          content: Text(
            "Akun untuk '$namaLengkap' (username: $username) telah berhasil didaftarkan. Silakan login.",
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: mainBlue),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(
                  context,
                ).pop(username); // Kembali ke LoginScreen, bawa username
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: mainBlue), // Latar belakang utama
          Positioned(
            // Wave bawah
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper:
                  BottomCurveClipper(), // Pastikan BottomCurveClipper didefinisikan
              child: Container(
                height: size.height * 0.15,
                color: const Color(0xFFB3E5FC).withOpacity(0.5),
              ),
            ),
          ),
          Center(
            // Menengahkan konten utama
            child: SingleChildScrollView(
              // Agar bisa discroll jika konten melebihi layar
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.075,
              ), // Padding kiri kanan
              child: Container(
                margin: EdgeInsets.only(
                  top: size.height * 0.08,
                  bottom: size.height * 0.05,
                ), // Margin atas bawah untuk form card
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Judul di tengah
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buat Akun Baru', // Judul form
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      _buildTextFormField(
                        'Nama Lengkap',
                        size,
                        _namaLengkapController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Nama lengkap tidak boleh kosong';
                          if (value.length < 3)
                            return 'Nama lengkap minimal 3 karakter';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'Email',
                        size,
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Email tidak boleh kosong';
                          if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value))
                            return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'No Handphone',
                        size,
                        _noHpController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'No handphone tidak boleh kosong';
                          if (value.length < 10)
                            return 'No handphone minimal 10 digit';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'Username',
                        size,
                        _usernameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Username tidak boleh kosong';
                          if (value.length < 4)
                            return 'Username minimal 4 karakter';
                          if (value.contains(' '))
                            return 'Username tidak boleh mengandung spasi';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'Password',
                        size,
                        _passwordController,
                        obscureText: _obscureText1,
                        isPassword: true,
                        onToggleObscure:
                            () =>
                                setState(() => _obscureText1 = !_obscureText1),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Password tidak boleh kosong';
                          if (value.length < 6)
                            return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'Konfirmasi Password',
                        size,
                        _konfirmasiPasswordController,
                        obscureText: _obscureText2,
                        isPassword: true,
                        onToggleObscure:
                            () =>
                                setState(() => _obscureText2 = !_obscureText2),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Konfirmasi password tidak boleh kosong';
                          if (value != _passwordController.text)
                            return 'Password tidak cocok';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _performRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlue,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Kembali ke LoginScreen
                          },
                          child: Text(
                            "Sudah punya akun? Login",
                            style: TextStyle(
                              color: mainBlue,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Tombol kembali di AppBar manual jika tidak menggunakan Scaffold AppBar
          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                10, // Sesuaikan dengan status bar
            left: 10,
            child: Material(
              // Bungkus dengan Material agar InkWell/IconButton bisa tampil efek ripple
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed:
                    () => Navigator.pop(
                      context,
                    ), // Kembali ke halaman sebelumnya (LoginScreen)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    Size size,
    TextEditingController controller, {
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13), // Sedikit mengurangi padding
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: size.width * 0.038),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: size.width * 0.038,
            color: Colors.black54,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainBlue, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: size.height * 0.017,
          ), // Sedikit mengurangi padding vertikal
          filled: true, // Memberi latar belakang pada text field
          fillColor: Colors.white, // Latar belakang putih
        ),
        validator: validator,
      ),
    );
  }
}

// Custom clipper untuk bagian bawah yang melengkung
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.2); // Mulai sedikit lebih atas
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.1,
    ); // Buat lebih landai
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width,
      0,
    ); // Buat lebih landai
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
