import 'package:flutter/material.dart';
import 'app_color.dart'; // Pastikan path ini benar
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';
// import 'package:NAMA_PAKET_ANDA/pages/akun_screen.dart'; // Untuk navigasi kembali jika perlu

class GantiSandiScreen extends StatefulWidget {
  const GantiSandiScreen({Key? key}) : super(key: key);

  @override
  State<GantiSandiScreen> createState() => _GantiSandiScreenState();
}

class _GantiSandiScreenState extends State<GantiSandiScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sandiLamaController = TextEditingController();
  final TextEditingController _sandiBaruController = TextEditingController();
  final TextEditingController _konfirmasiSandiBaruController =
      TextEditingController();

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

  void _prosesGantiSandi() {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    if (_formKey.currentState!.validate()) {
      AppUser? currentUser = UserDatabase.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: Tidak ada pengguna yang login.'),
          ),
        );
        return;
      }

      String sandiLama = _sandiLamaController.text;
      String sandiBaru = _sandiBaruController.text;
      // String konfirmasiSandiBaru = _konfirmasiSandiBaruController.text; // Sudah divalidasi di form

      // Verifikasi kata sandi lama
      if (currentUser.password != sandiLama) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Kata sandi lama salah!'),
          ),
        );
        return;
      }

      // Pastikan kata sandi baru tidak sama dengan kata sandi lama
      if (sandiBaru == sandiLama) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Kata sandi baru tidak boleh sama dengan kata sandi lama.',
            ),
          ),
        );
        return;
      }

      // Update password di UserDatabase
      bool berhasilUpdate = UserDatabase.updateUserPassword(
        currentUser.username,
        sandiBaru,
      );

      if (berhasilUpdate && mounted) {
        // Tambahkan pengecekan mounted
        _showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Gagal memperbarui kata sandi. Coba lagi.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Harap isi semua field dengan benar.'),
        ),
      );
    }
  }

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
          content: const Text('Kata sandi Anda telah berhasil diperbarui.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: mainBlue),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke halaman Akun
              },
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
      backgroundColor: screenBgLightBlue, // Warna latar dari app_colors.dart
      appBar: AppBar(
        title: const Text('Ganti Kata Sandi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold, // Dibuat bold agar lebih jelas
          color: Colors.white,
        ),
        backgroundColor: mainBlue, // Warna AppBar dari app_colors.dart
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0, // Menghilangkan shadow jika diinginkan
      ),
      body: SingleChildScrollView(
        // Agar bisa di-scroll jika konten melebihi layar
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07, // Padding kiri kanan
          vertical: size.height * 0.03, // Padding atas bawah
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              Text(
                'MASUKKAN KATA SANDI LAMA & BARU ANDA UNTUK MENGGANTI KATA SANDI',
                style: TextStyle(
                  color: Colors.black87, // Warna teks lebih standar
                  fontSize:
                      size.width * 0.038, // Sedikit menyesuaikan ukuran font
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Maname', // Pastikan font ini ada
                ),
                textAlign: TextAlign.center, // Agar teks deskripsi di tengah
              ),
              const SizedBox(height: 30),

              _buildPasswordField(
                label: 'Kata Sandi Lama',
                size: size,
                controller: _sandiLamaController,
                obscureText: _obscureSandiLama,
                onToggleObscure: () {
                  setState(() {
                    _obscureSandiLama = !_obscureSandiLama;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi lama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * 0.015), // Spasi antar field

              _buildPasswordField(
                label: 'Kata Sandi Baru',
                size: size,
                controller: _sandiBaruController,
                obscureText: _obscureSandiBaru,
                onToggleObscure: () {
                  setState(() {
                    _obscureSandiBaru = !_obscureSandiBaru;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * 0.015),

              _buildPasswordField(
                label: 'Ulang Kata Sandi Baru',
                size: size,
                controller: _konfirmasiSandiBaruController,
                obscureText: _obscureKonfirmasiSandiBaru,
                onToggleObscure: () {
                  setState(() {
                    _obscureKonfirmasiSandiBaru = !_obscureKonfirmasiSandiBaru;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi baru tidak boleh kosong';
                  }
                  if (value != _sandiBaruController.text) {
                    return 'Konfirmasi kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ), // Spasi lebih besar sebelum tombol

              SizedBox(
                width: double.infinity, // Tombol selebar layar
                child: ElevatedButton(
                  onPressed: _prosesGantiSandi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mainBlue, // Warna tombol dari app_colors.dart
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
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
    required Size size,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.02,
      ), // Spasi standar antar field
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
          fillColor: Colors.white, // Latar belakang field putih
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: mainBlue,
              width: 1.5,
            ), // Dari app_colors.dart
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
