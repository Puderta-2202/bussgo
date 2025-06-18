import 'package:bussgo/models/tiket_api_model.dart';
import 'package:bussgo/services/tiket_service_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'akun_screen.dart';
import 'app_color.dart';
import 'nav_bar.dart';

class TiketSayaPage extends StatefulWidget {
  const TiketSayaPage({Key? key}) : super(key: key);

  @override
  State<TiketSayaPage> createState() => _TiketSayaPageState();
}

class _TiketSayaPageState extends State<TiketSayaPage> {
  final int _currentIndex = 1;
  late Future<List<TiketFromApi>> _futureTiket;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    setState(() {
      _futureTiket = TiketServiceApi.getMyTickets(); // Memanggil service API
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
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AkunScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman belum tersedia.')),
        );
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
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTickets();
        },
        child: FutureBuilder<List<TiketFromApi>>(
          future: _futureTiket,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Gagal memuat tiket.\n${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
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
                      onPressed:
                          () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          ),
                      child: const Text(
                        'Cari Tiket Sekarang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            final daftarTiket = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarTiket.length,
              itemBuilder: (context, index) {
                final tiket = daftarTiket[index];
                final jadwal = tiket.jadwalKeberangkatan;
                final bus = jadwal['bus'];
                final tanggal = DateFormat(
                  'EEEE, dd MMMM yyyy',
                  'id_ID',
                ).format(DateTime.parse(jadwal['tanggal_berangkat']));
                final waktu =
                    "${jadwal['jam_berangkat']} - ${jadwal['jam_sampai']}";

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bus: ${bus?['nama'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: mainBlue,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    tiket.statusPembayaran == 'berhasil'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tiket.statusPembayaran
                                    .replaceAll('_', ' ')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      tiket.statusPembayaran == 'berhasil'
                                          ? Colors.green.shade800
                                          : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildTicketInfoRow(
                          Icons.calendar_today_outlined,
                          "Tanggal",
                          tanggal,
                        ),
                        _buildTicketInfoRow(
                          Icons.access_time_outlined,
                          "Waktu",
                          waktu,
                        ),
                        _buildTicketInfoRow(
                          Icons.event_seat_outlined,
                          "Kursi",
                          tiket.nomorKursi.isNotEmpty
                              ? tiket.nomorKursi.join(', ')
                              : '-',
                        ),
                        _buildTicketInfoRow(
                          Icons.confirmation_number_outlined,
                          "ID Booking",
                          tiket.kodeBooking,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
