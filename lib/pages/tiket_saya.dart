import 'package:flutter/material.dart';
import 'home_screen.dart';

const Color mainBlue = Color(0xFF1A9AEB);

class Tiket {
  final String id;
  final String jenisTiket;
  final String tanggalKeberangkatan;
  final String waktuKeberangkatan;
  final String kotaAsal;
  final String kotaTujuan;
  final String namaBus;
  final String nomorKursi;
  final String harga;

  Tiket({
    required this.id,
    this.jenisTiket = 'Tiket Reguler', // Default value
    required this.tanggalKeberangkatan,
    required this.waktuKeberangkatan,
    required this.kotaAsal,
    required this.kotaTujuan,
    this.namaBus = "Bus GO Express",
    this.nomorKursi = "Belum Dipilih",
    this.harga = "N/A",
  });
}
// --- AKHIR MODEL TIKET ---

class TiketSayaPage extends StatefulWidget {
  final Tiket? tiketDibeli;

  const TiketSayaPage({Key? key, this.tiketDibeli}) : super(key: key);

  @override
  State<TiketSayaPage> createState() => _TiketSayaPageState();
}

class _TiketSayaPageState extends State<TiketSayaPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
    // Tambahkan navigasi untuk Promo dan Akun jika perlu
    // else if (index == 2) { Navigator.push... ke PromoPage }
    // else if (index == 3) { Navigator.push... ke AkunPage }
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        int index =
            label == 'Beranda'
                ? 0
                : label == 'Tiket Saya'
                ? 1
                : label == 'Promo'
                ? 2
                : 3;
        _onItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? mainBlue : Colors.grey[400], size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? mainBlue : Colors.grey[400],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data tiket dari widget.tiketDibeli
    // Jika tidak ada tiket, tampilkan pesan atau UI yang sesuai
    final Tiket? tiket = widget.tiketDibeli;

    return Scaffold(
      backgroundColor: const Color(
        0xFFE3F2FD,
      ), // Menggunakan warna latar belakang lebih netral
      appBar: AppBar(
        backgroundColor: mainBlue, // Menggunakan mainBlue agar konsisten
        title: const Text(
          'Tiket Saya',
          style: TextStyle(
            fontFamily: 'Kadwa',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kembali ke HomeScreen jika ditekan, atau sesuai alur yang diinginkan
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Jika tidak bisa pop (misalnya halaman ini adalah root setelah login),
              // navigasi ke HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: Colors.white),
            onPressed: () {
              // aksi icon receipt
              if (tiket != null) {
                // Contoh aksi: tampilkan detail lebih lanjut atau opsi cetak
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Melihat detail tiket ID: ${tiket.id}'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body:
          tiket == null
              ? Center(
                // Tampilan jika tidak ada tiket
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bus_alert, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Tiket',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Cari Tiket Sekarang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                // Tampilan jika ada tiket
                padding: const EdgeInsets.all(16),
                child: Container(
                  // Ini adalah kartu tiket utama
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna kartu tiket
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize
                            .min, // Agar Column tidak memenuhi semua tinggi
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tiket.jenisTiket, // Data dinamis
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Sedikit lebih besar
                              color: mainBlue,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // aksi tombol lihat tiket (misal: tampilkan QR Code, detail lebih lanjut)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Menampilkan detail tiket: ${tiket.id}',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.orangeAccent, // Warna tombol beda
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16, // Padding lebih
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // Bentuk tombol
                              ),
                            ),
                            child: const Text(
                              'Lihat E-Tiket', // Teks tombol lebih jelas
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1), // Pemisah

                      _buildTicketInfoRow(
                        Icons.calendar_today_outlined,
                        "Tanggal",
                        tiket.tanggalKeberangkatan,
                      ),
                      _buildTicketInfoRow(
                        Icons.access_time_outlined,
                        "Waktu",
                        tiket.waktuKeberangkatan,
                      ),
                      _buildTicketInfoRow(
                        Icons.bus_alert_outlined,
                        "Armada",
                        tiket.namaBus,
                      ), // Menampilkan nama bus
                      _buildTicketInfoRow(
                        Icons.event_seat_outlined,
                        "Kursi",
                        tiket.nomorKursi,
                      ), // Menampilkan nomor kursi
                      _buildTicketInfoRow(
                        Icons.confirmation_number_outlined,
                        "ID Booking",
                        tiket.id,
                      ), // Menampilkan ID Booking

                      const SizedBox(height: 15),
                      // Rute dengan alignment dan panah tengah
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Dari",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  tiket.kotaAsal, // Data dinamis
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 24,
                              color: mainBlue,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Ke",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  tiket.kotaTujuan, // Data dinamis
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // Mendorong ke bawah jika ada ruang
                      Center(
                        child: Text(
                          "Terima kasih telah menggunakan BusGO!",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: Container(
        // ... (bottomNavigationBar tetap sama) ...
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.home_outlined,
              'Beranda',
              _selectedIndex == 0,
            ), // Mengganti ikon
            _buildNavItem(
              Icons.confirmation_number_outlined,
              'Tiket Saya',
              _selectedIndex == 1,
            ),
            _buildNavItem(
              Icons.local_offer_outlined,
              'Promo',
              _selectedIndex == 2,
            ),
            _buildNavItem(Icons.person_outline, 'Akun', _selectedIndex == 3),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris info tiket
  Widget _buildTicketInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
