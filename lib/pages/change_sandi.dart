import 'package:flutter/material.dart';
import 'package:bussgo/services/auth_service.dart';
import 'app_color.dart';
import 'loginscreen.dart';

class GantiSandiScreen extends StatefulWidget {
  const GantiSandiScreen({Key? key}) : super(key: key);

  @override
  State<GantiSandiScreen> createState() => _GantiSandiScreenState();
}

class _GantiSandiScreenState extends State<GantiSandiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sandiLamaController = TextEditingController();
  final _sandiBaruController = TextEditingController();
  final _konfirmasiSandiBaruController = TextEditingController();
  bool _isLoading = false;

  bool _obscureSandiLama = true;
  bool _obscureSandiBaru = true;
  bool _obscureKonfirmasiSandiBaru = true;

  @override
  void dispose() {
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiSandiBaruController.dispose();
    super.dispose();
  }

  // --- FUNGSI GANTI SANDI DIPERBAIKI UNTUK MENGGUNAKAN API ---
  Future<void> _prosesGantiSandi() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService.changePassword(
          currentPassword: _sandiLamaController.text,
          newPassword: _sandiBaruController.text,
          newPasswordConfirmation: _konfirmasiSandiBaruController.text,
        );
        if (mounted) _showSuccessDialog(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(e.toString().replaceFirst('Exception: ', '')),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // --- DIALOG SUKSES DIPERBAIKI AGAR LOGOUT DAN KEMBALI KE LOGIN ---
  void _showSuccessDialog(BuildContext context) {
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
              Text('Berhasil'),
            ],
          ),
          content: const Text(
            'Kata sandi berhasil diperbarui. Untuk keamanan, silakan login kembali.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: mainBlue),
              onPressed: () async {
                // Hapus dialog dari layar
                Navigator.of(context).pop();

                // Panggil fungsi logout dari service
                await AuthService.logout();

                if (!mounted) return;

                // Arahkan ke halaman Login dan hapus semua halaman sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        title: const Text('Ganti Kata Sandi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Untuk keamanan, kata sandi lama Anda diperlukan untuk mengatur kata sandi baru.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: size.width * 0.038,
                ),
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                label: 'Kata Sandi Lama',
                controller: _sandiLamaController,
                obscureText: _obscureSandiLama,
                onToggleObscure:
                    () =>
                        setState(() => _obscureSandiLama = !_obscureSandiLama),
                validator:
                    (v) =>
                        (v == null || v.isEmpty)
                            ? 'Kata sandi lama tidak boleh kosong'
                            : null,
              ),
              _buildPasswordField(
                label: 'Kata Sandi Baru',
                controller: _sandiBaruController,
                obscureText: _obscureSandiBaru,
                onToggleObscure:
                    () =>
                        setState(() => _obscureSandiBaru = !_obscureSandiBaru),
                validator:
                    (v) =>
                        (v != null && v.length < 8)
                            ? 'Password minimal 8 karakter'
                            : null,
              ),
              _buildPasswordField(
                label: 'Ulang Kata Sandi Baru',
                controller: _konfirmasiSandiBaruController,
                obscureText: _obscureKonfirmasiSandiBaru,
                onToggleObscure:
                    () => setState(
                      () =>
                          _obscureKonfirmasiSandiBaru =
                              !_obscureKonfirmasiSandiBaru,
                    ),
                validator: (v) {
                  if (v != _sandiBaruController.text)
                    return 'Konfirmasi password tidak cocok';
                  return null;
                },
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _prosesGantiSandi,
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Perbarui',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.bold,
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    // UI helper ini tidak berubah, sudah benar
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: size.width * 0.038),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: size.width * 0.038,
            color: Colors.black54,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: mainBlue, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: onToggleObscure,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
