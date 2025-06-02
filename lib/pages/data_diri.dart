import 'package:flutter/material.dart';
import 'app_color.dart'; // Untuk mainBlue dan warna lain jika perlu
import 'package:bussgo/model/app_user.dart';
import 'package:bussgo/model/user_database.dart';

class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({Key? key}) : super(key: key);

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: mainBlue.withOpacity(0.8),
            size: 22,
          ), // Warna ikon disesuaikan
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Warna label disesuaikan
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(
                    fontSize: 16, // Ukuran font nilai sedikit disesuaikan
                    fontWeight: FontWeight.w500,
                    color: Colors.black87, // Warna nilai disesuaikan
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? currentUser = UserDatabase.currentUser;

    return Scaffold(
      backgroundColor:
          screenBgLightBlue, // Latar belakang utama halaman menjadi biru muda
      appBar: AppBar(
        title: const Text('Data Diri'),
        backgroundColor: mainBlue, // AppBar tetap mainBlue
        elevation:
            0, // Bisa juga diberi elevasi standar jika diinginkan (misal 4.0)
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          currentUser == null
              ? Center(
                child: Column(
                  // Dibuat Column agar bisa tambah tombol jika perlu
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada data pengguna.\nSilakan login kembali.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(
                  16.0,
                  24.0,
                  16.0,
                  24.0,
                ), // Padding disesuaikan
                children: [
                  Center(
                    child: Column(
                      // Tambahkan Column untuk nama di bawah avatar
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: mainBlue.withOpacity(
                            0.1,
                          ), // Warna latar avatar disesuaikan
                          child: Icon(
                            Icons.person_rounded, // Ikon diganti
                            size: 60,
                            color: mainBlue, // Warna ikon disesuaikan
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (currentUser.namaLengkap.isNotEmpty)
                          Text(
                            currentUser.namaLengkap,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (currentUser.namaLengkap.isNotEmpty)
                          const SizedBox(height: 4),
                        Text(
                          // Menampilkan username sebagai sub-info
                          "@${currentUser.username}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    // Kartu untuk detail info
                    elevation: 1.0, // Sedikit shadow
                    color: Colors.white, // Kartu berwarna putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        16.0,
                      ), // Padding dalam kartu
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.badge_outlined, // Ikon yang lebih sesuai
                            'Nama Lengkap',
                            currentUser.namaLengkap,
                          ),
                          const Divider(color: Colors.black12),
                          _buildInfoRow(
                            context,
                            Icons.email_outlined,
                            'Email',
                            currentUser.email,
                          ),
                          const Divider(color: Colors.black12),
                          _buildInfoRow(
                            context,
                            Icons
                                .phone_iphone_outlined, // Ikon yang lebih sesuai
                            'No. Handphone',
                            currentUser.noHandphone,
                          ),
                          // Username sudah ditampilkan di atas, jadi bisa dihilangkan dari sini jika mau
                          // const Divider(color: Colors.black12),
                          // _buildInfoRow(
                          //   context,
                          //   Icons.account_circle_outlined,
                          //   'Username',
                          //   currentUser.username,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // ... (Tombol Edit Data Diri jika ada)
                ],
              ),
    );
  }
}
