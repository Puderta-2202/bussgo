import 'package:flutter/material.dart';
import 'app_color.dart';
// Import service API yang sudah kita buat
import 'package:bussgo/services/auth_service.dart';

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
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isLoading = false; // Tambahkan state untuk loading

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    // _usernameController.dispose(); // Hapus
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  // --- LOGIKA API BARU ---
  void _performRegister() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mulai loading
      });

      try {
        // Panggil service API kita
        final response = await AuthService.register(
          name: _namaLengkapController.text.trim(),
          email: _emailController.text.trim(),
          noHandphone: _noHpController.text.trim(),
          alamat: _alamatController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _konfirmasiPasswordController.text,
        );

        if (mounted) {
          // Tampilkan dialog sukses
          _showRegistrationSuccessDialog(
            context,
            response['user']['nama_lengkap'],
          );
        }
      } catch (e) {
        // Tampilkan pesan error dari API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[600],
            content: Text(e.toString().replaceFirst('Exception: ', '')),
          ),
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

  // Modifikasi dialog agar lebih sederhana
  void _showRegistrationSuccessDialog(
    BuildContext context,
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
            "Akun untuk '$namaLengkap' telah berhasil dibuat. Silakan login dengan email Anda.",
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: mainBlue),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke LoginScreen
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
          // ... (sebagian besar UI Anda tetap sama) ...
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
              child: Container(
                margin: EdgeInsets.only(
                  top: size.height * 0.08,
                  bottom: size.height * 0.05,
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buat Akun Baru',
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
                          /* validasi tetap sama */
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
                          /* validasi tetap sama */
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
                          /* validasi tetap sama */
                          if (value == null || value.isEmpty)
                            return 'No handphone tidak boleh kosong';
                          if (value.length < 10)
                            return 'No handphone minimal 10 digit';
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        'Alamat',
                        size,
                        _alamatController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
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
                          /* validasi tetap sama */
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
                          /* validasi tetap sama */
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
                          // Nonaktifkan tombol saat loading dan tampilkan indicator
                          onPressed: _isLoading ? null : _performRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlue,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Text(
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
                          onPressed: () => Navigator.pop(context),
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
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTextFormField tetap sama, tidak perlu diubah
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
      padding: const EdgeInsets.only(bottom: 13),
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
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }
}

// ... (Kode CustomClipper Anda tetap sama)
