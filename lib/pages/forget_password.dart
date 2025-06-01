import 'package:flutter/material.dart';
// import 'home_screen.dart';
import 'loginscreen.dart';
import 'app_color.dart';
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key); // Tambahkan const

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  AppUser? _verifiedUser; // Untuk menyimpan user yang terverifikasi

  @override
  void dispose() {
    _emailController.dispose();
    _noHpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _verifyUser() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_emailController.text.isEmpty || _noHpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Email dan No Handphone harus diisi.'),
        ),
      );
      return;
    }
    // Di aplikasi nyata, Anda mungkin ingin validasi format email dan no HP di sini juga

    AppUser? user = UserDatabase.findUserByEmailAndPhone(
      _emailController.text.trim(),
      _noHpController.text.trim(),
    );

    if (user != null) {
      setState(() {
        _verifiedUser = user;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Pengguna terverifikasi: ${user.namaLengkap}. Silakan masukkan password baru.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email atau No Handphone tidak ditemukan/cocok.'),
        ),
      );
      setState(() {
        _verifiedUser = null; // Pastikan reset jika gagal
      });
    }
  }

  void _updatePassword() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      if (_verifiedUser != null) {
        bool success = UserDatabase.updateUserPassword(
          _verifiedUser!
              .username, // Gunakan username dari user yang terverifikasi
          _newPasswordController.text,
        );

        if (success) {
          _showSuccessDialog(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Gagal memperbarui password. Coba lagi.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Harap verifikasi email dan no handphone terlebih dahulu.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganti Kata Sandi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        backgroundColor: mainBlue, // Dari app_colors.dart
        leading: IconButton(
          // Tombol kembali
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: screenBgLightBlue, // Dari app_colors.dart
        child: SafeArea(
          child: Padding(
            // Tambahkan Padding di sini agar tidak terlalu mepet ke tepi
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Form(
              // Bungkus dengan Form
              key: _formKey,
              child: ListView(
                // Ganti Column dengan ListView agar bisa discroll
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text(
                    _verifiedUser == null
                        ? 'Masukkan Email dan No Handphone Anda untuk verifikasi.'
                        : 'Masukkan kata sandi baru untuk ${_verifiedUser!.namaLengkap!.isNotEmpty ? _verifiedUser!.namaLengkap : _verifiedUser!.username}.',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Maname', // Pastikan font ini ada
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  if (_verifiedUser == null) ...[
                    // Tampilkan field verifikasi jika user belum terverifikasi
                    _buildTextFormField(
                      'Email Terdaftar',
                      size,
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email tidak boleh kosong';
                        if (!RegExp(
                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value))
                          return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      'No Handphone Terdaftar',
                      size,
                      _noHpController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'No handphone tidak boleh kosong';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _verifyUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.018,
                            horizontal: size.width * 0.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Verifikasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (_verifiedUser != null) ...[
                    // Tampilkan field password baru jika user sudah terverifikasi
                    _buildTextFormField(
                      'Kata Sandi Baru',
                      size,
                      _newPasswordController,
                      obscureText: _obscureNewPassword,
                      isPassword: true,
                      onToggleObscure:
                          () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password baru tidak boleh kosong';
                        if (value.length < 6)
                          return 'Password minimal 6 karakter';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      'Ulang Kata Sandi Baru',
                      size,
                      _confirmNewPasswordController,
                      obscureText: _obscureConfirmPassword,
                      isPassword: true,
                      onToggleObscure:
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Konfirmasi password tidak boleh kosong';
                        if (value != _newPasswordController.text)
                          return 'Password tidak cocok';
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.018,
                            horizontal: size.width * 0.25,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Perbarui Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: size.height * 0.05,
                  ), // Memberi ruang di bawah tombol
                ],
              ),
            ),
          ),
        ),
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
      padding: EdgeInsets.only(bottom: size.height * 0.02), // Disesuaikan
      child: TextFormField(
        // Menggunakan TextFormField
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: size.width * 0.038),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: size.width * 0.038,
            color: Colors.black87,
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
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Pengguna harus menekan tombol
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Kata Sandi Diperbarui'),
            ],
          ),
          content: const Text(
            'Kata sandi Anda telah berhasil diperbarui. Silakan login kembali.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: mainBlue),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Arahkan ke LoginScreen dan hapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ), // Pastikan LoginScreen diimpor
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Login Sekarang',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
