import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'akun_screen.dart';
import 'app_color.dart';
import 'nav_bar.dart';
import 'tiket_service.dart';

// --- MODEL TIKET (Definisi tetap sama) ---
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
    this.jenisTiket = 'Tiket Reguler',
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
  // Hapus parameter tiketDibeli, karena kita akan load dari service
  const TiketSayaPage({Key? key, required}) : super(key: key);

  @override
  State<TiketSayaPage> createState() => _TiketSayaPageState();
}

class _TiketSayaPageState extends State<TiketSayaPage> {
  final int _currentIndex = 1; // Index untuk halaman Tiket Saya
  List<Tiket> _daftarTiketDibeli = []; // List untuk menampung tiket

  @override
  void initState() {
    super.initState();
    _loadPurchasedTickets();
  }

  void _loadPurchasedTickets() {
    setState(() {
      _daftarTiketDibeli = TicketService.getPurchasedTickets();
    });
  }

  void _onItemTapped(int index) {
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
        break; // Sudah di halaman ini
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Promo belum tersedia.')),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AkunScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
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
              if (_daftarTiketDibeli.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menampilkan semua detail tiket...')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tidak ada tiket untuk ditampilkan.')),
                );
              }
            },
          ),
        ],
      ),
      body:
          _daftarTiketDibeli.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bus_alert, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Tiket Dipesan',
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
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _daftarTiketDibeli.length,
                itemBuilder: (context, index) {
                  final tiket = _daftarTiketDibeli[index];
                  return Card(
                    // Menggunakan Card untuk setiap tiket agar lebih rapi
                    elevation: 2.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tiket.jenisTiket,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: mainBlue,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Menampilkan detail tiket: ${tiket.id}',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Lihat E-Tiket',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
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
                          ),
                          _buildTicketInfoRow(
                            Icons.event_seat_outlined,
                            "Kursi",
                            tiket.nomorKursi,
                          ),
                          _buildTicketInfoRow(
                            Icons.confirmation_number_outlined,
                            "ID Booking",
                            tiket.id,
                          ),
                          const SizedBox(height: 15),
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
                                      tiket.kotaAsal,
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
                                      tiket.kotaTujuan,
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
                          // const Spacer(), // Tidak perlu spacer di dalam item ListView
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "ID: ${tiket.id}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SharedBottomNavBar(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

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
