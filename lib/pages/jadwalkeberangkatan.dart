import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detail_tiket.dart';
import 'app_color.dart';

// --- Model Class JadwalKeberangkatanModel (tetap sama seperti sebelumnya) ---
class JadwalKeberangkatanModel {
  final String waktuBerangkat;
  final String waktuSampai;
  final String harga;
  final String namaBus;
  final bool isAvailable;

  JadwalKeberangkatanModel({
    required this.waktuBerangkat,
    required this.waktuSampai,
    required this.harga,
    required this.namaBus,
    this.isAvailable = true,
  });

  String get statusTiket {
    return isAvailable ? "Pesan Sekarang!" : "Tiket Habis!! Makanya Buruan";
  }

  Color get statusTiketColor {
    return isAvailable ? Colors.green.shade700 : Colors.red.shade700;
  }
}
// --- Akhir Model Class ---

// const Color mainBlue = Color(0xFF1A9AEB);
// const Color cardLightBlueJadwal = Color(
//   0xFFD1E9FA,
// ); // Beri nama berbeda jika warna kartu beda
// const Color screenBgLightBlueJadwal = Color(0xFFE3F2FD);

class JadwalKeberangkatanScreen extends StatelessWidget {
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final int jumlahPenumpang; // Tambahkan ini

  const JadwalKeberangkatanScreen({
    Key? key,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jumlahPenumpang, // Tambahkan ini
  }) : super(key: key);

  List<JadwalKeberangkatanModel> _getDummyJadwal() {
    // ... (data dummy jadwal tetap sama)
    return [
      JadwalKeberangkatanModel(
        waktuBerangkat: "08.00 AM",
        waktuSampai: "09.00 AM",
        harga: "100K",
        namaBus: "Bus Cepat A",
        isAvailable: true,
      ),
      JadwalKeberangkatanModel(
        waktuBerangkat: "10.00 AM",
        waktuSampai: "11.00 AM",
        harga: "90K",
        namaBus: "Bus Nyaman B",
        isAvailable: false,
      ),
      JadwalKeberangkatanModel(
        waktuBerangkat: "08.00 PM",
        waktuSampai: "09.00 PM",
        harga: "120K",
        namaBus: "Bus Malam C",
        isAvailable: true,
      ),
      JadwalKeberangkatanModel(
        waktuBerangkat: "02.00 PM",
        waktuSampai: "03.30 PM",
        harga: "95K",
        namaBus: "Bus Express D",
        isAvailable: true,
      ),
      JadwalKeberangkatanModel(
        waktuBerangkat: "04.00 PM",
        waktuSampai: "05.00 PM",
        harga: "110K",
        namaBus: "Bus Pariwisata E",
        isAvailable: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<JadwalKeberangkatanModel> daftarJadwal = _getDummyJadwal();
    String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(tanggalKeberangkatan);

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        // ... (AppBar tetap sama) ...
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              kotaAsal,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ),
            Text(
              kotaTujuan,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Judul dan tanggal tetap sama) ...
            Text(
              "Pilih Jadwal Keberangkatan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: daftarJadwal.length,
                itemBuilder: (context, index) {
                  final jadwal = daftarJadwal[index];
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: cardLightBlueJadwal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap:
                          jadwal.isAvailable
                              ? () {
                                // MODIFIKASI NAVIGASI DI SINI
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailPerjalananScreen(
                                          kotaAsal: kotaAsal,
                                          kotaTujuan: kotaTujuan,
                                          tanggalKeberangkatan:
                                              tanggalKeberangkatan,
                                          jadwalTerpilih: jadwal,
                                          jumlahPenumpang:
                                              jumlahPenumpang, // Kirim jumlah penumpang
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: Padding(
                        // ... (Isi Card tetap sama) ...
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jadwal.namaBus,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: mainBlue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoColumn(
                                  "Berangkat",
                                  jadwal.waktuBerangkat,
                                ),
                                _buildInfoColumn("Sampai", jadwal.waktuSampai),
                                _buildInfoColumn(
                                  "IDR",
                                  jadwal.harga,
                                  isPrice: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                jadwal.statusTiket,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: jadwal.statusTiketColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, {bool isPrice = false}) {
    // ... (_buildInfoColumn tetap sama) ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isPrice ? Colors.green[700] : Colors.black87,
          ),
        ),
      ],
    );
  }
}
