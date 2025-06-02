import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'tiket_saya.dart';
import 'app_color.dart';
import 'nav_bar.dart';
import 'loginscreen.dart';
import 'change_sandi.dart';
import 'data_diri.dart';
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({Key? key}) : super(key: key);

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  final int _currentIndex = 3;

  void _handleBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TiketSayaPage()),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Promo belum tersedia.')),
        );
        break;
      case 3:
        break;
    }
  }

  void _logoutUser() {
    UserDatabase.logoutUser(); // <-- PANGGIL LOGOUT DARI SERVICE

    // Contoh simulasi reset state lain jika diperlukan:
    // TicketService.clearAllTickets();
    // HomeScreenState.updateAndFormatBusPayBalance(0.0, stateSetter: null); // Mungkin perlu cara lain untuk refresh HomeScreen

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data pengguna yang sedang login
    final AppUser? currentUser = UserDatabase.currentUser;
    String? displayName = "Pengguna"; // Default jika tidak ada info
    if (currentUser != null) {
      // Prioritaskan namaLengkap, jika tidak ada, gunakan username
      displayName =
          currentUser.namaLengkap.isNotEmpty
              ? currentUser.namaLengkap
              : currentUser.username;
    }

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Akun',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Akun",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  // Tampilkan nama pengguna yang login
                  "Hai $displayName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "AKUN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAccountOptionItem(
            context,
            title: "Data Diri",
            onTap: () {
              // --- AWAL MODIFIKASI NAVIGASI ---
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataDiriScreen()),
              );
              // --- AKHIR MODIFIKASI NAVIGASI ---
            },
          ),
          _buildAccountOptionItem(
            context,
            title: "Ganti Kata Sandi",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GantiSandiScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildAccountOptionItem(
            context,
            title: "Keluar",
            isLogout: true,
            onTap: _logoutUser,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SharedBottomNavBar(
          currentIndex: _currentIndex,
          onItemTapped: _handleBottomNavTapped,
        ),
      ),
    );
  }

  Widget _buildAccountOptionItem(
    BuildContext context, {
    required String title,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red[700] : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isLogout ? Colors.red[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
