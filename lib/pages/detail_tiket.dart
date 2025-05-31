import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'jadwalkeberangkatan.dart' show JadwalKeberangkatanModel;
import 'perjalanan_screen.dart';
import 'app_color.dart';
// const Color mainBlue = Color(0xFF1A9AEB);
// const Color cardLightBlue = Color(0xFFD1E9FA);
// const Color screenBgLightBlue = Color(0xFFE3F2FD);

class DetailPerjalananScreen extends StatefulWidget {
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final JadwalKeberangkatanModel jadwalTerpilih;
  final int jumlahPenumpang;

  const DetailPerjalananScreen({
    Key? key,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jadwalTerpilih,
    required this.jumlahPenumpang,
  }) : super(key: key);

  @override
  State<DetailPerjalananScreen> createState() => _DetailPerjalananScreenState();
}

class _DetailPerjalananScreenState extends State<DetailPerjalananScreen> {
  bool _termsAccepted = false;

  // Helper untuk konversi harga "100K" -> 100000
  int _parseHarga(String hargaString) {
    String numericString = hargaString.replaceAll(
      RegExp(r'K', caseSensitive: false),
      '000',
    );
    numericString = numericString.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    ); // Hapus karakter non-numerik lain
    return int.tryParse(numericString) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(widget.tanggalKeberangkatan);
    String jamPerjalanan =
        "${widget.jadwalTerpilih.waktuBerangkat} - ${widget.jadwalTerpilih.waktuSampai}";

    int hargaPerTiket = _parseHarga(widget.jadwalTerpilih.harga);
    int totalHarga = hargaPerTiket * widget.jumlahPenumpang;
    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);
    String formattedHargaPerTiket = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(hargaPerTiket);

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
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
              widget.kotaAsal,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ),
            Text(
              widget.kotaTujuan,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Perjalanan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1), // Biru lebih gelap untuk judul
              ),
            ),
            const SizedBox(height: 16),

            // Card Detail Perjalanan
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jamPerjalanan,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.kotaAsal,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.black54,
                        size: 18,
                      ),
                      Text(
                        widget.kotaTujuan,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Info Kontak (Dummy)
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kontak Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow("Nama", "Lord Abdi (Contoh)"),
                  _buildInfoRow("Email", "lordabdi@example.com"),
                  _buildInfoRow("No. Handphone", "0888-0923-xxxx"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Detail Harga
            _buildDetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Detail Harga",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Penumpang",
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      Text(
                        "${widget.jumlahPenumpang} x $formattedHargaPerTiket",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        formattedTotalHarga,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Term and Condition & Tombol Pembayaran
            _buildDetailCard(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text(
                      "Saya menyetujui Term and condition",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: mainBlue,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _termsAccepted
                              ? () {
                                // Aksi ke halaman pembayaran - MODIFIKASI DI SINI
                                int hargaPerTiket = _parseHarga(
                                  widget.jadwalTerpilih.harga,
                                ); // Pastikan _parseHarga ada
                                int totalHarga =
                                    hargaPerTiket * widget.jumlahPenumpang;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PembayaranScreen(
                                          totalHarga: totalHarga,
                                          kotaAsal: '',
                                          kotaTujuan: '',
                                          tanggalKeberangkatan:
                                              widget.tanggalKeberangkatan,
                                          jadwalTerpilih: widget.jadwalTerpilih,
                                          jumlahPenumpang:
                                              widget.jumlahPenumpang,
                                          // orderId: "generate_atau_ambil_order_id_disini", // Contoh jika ada orderId
                                        ),
                                  ),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Pilih Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Card(
      elevation: 0, // Sesuai gambar, tidak ada shadow yang kuat
      color: cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // Lebar tetap untuk label
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const Text(
            ": ",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
