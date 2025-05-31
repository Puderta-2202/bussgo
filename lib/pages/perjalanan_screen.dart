import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pembayaran.dart'; // Ganti 'bussgo'
import 'jadwalkeberangkatan.dart'
    show JadwalKeberangkatanModel; // Ganti 'bussgo'
import 'app_color.dart'; // <-- IMPOR WARNA BARU, GANTI 'bussgo'

// HAPUS DEFINISI WARNA LOKAL DARI SINI
// const Color mainBlue = Color(0xFF1A9AEB);
// ... warna lain ...

// Enum untuk metode pembayaran (bisa tetap di sini atau pindah ke file model/enum)
enum MetodePembayaran { none, busPay, qris, mBanking }

class PembayaranScreen extends StatefulWidget {
  // ... (Konstruktor dan field tidak berubah dari jawaban sebelumnya, sudah menerima semua detail perjalanan)
  final int totalHarga;
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final JadwalKeberangkatanModel jadwalTerpilih;
  final int jumlahPenumpang;

  const PembayaranScreen({
    Key? key,
    required this.totalHarga,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jadwalTerpilih,
    required this.jumlahPenumpang,
  }) : super(key: key);

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  // ... (Isi state dan fungsi tidak berubah, warna akan diambil dari app_colors.dart)
  late DateTime _batasWaktuPembayaran;
  MetodePembayaran _selectedPaymentMethod = MetodePembayaran.none;
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    /* ... implementasi tetap ... */
    super.initState();
    _batasWaktuPembayaran = DateTime.now().add(const Duration(minutes: 30));
  }

  void _selectPaymentMethod(MetodePembayaran method) {
    /* ... implementasi tetap ... */
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _lanjutkanPembayaran() {
    /* ... implementasi tetap, navigasi ke KonfirmasiPembayaranScreen ... */
    if (_selectedPaymentMethod == MetodePembayaran.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih metode pembayaran terlebih dahulu.'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => KonfirmasiPembayaranScreen(
              // Pastikan NamaKelas KonfirmasiPembayaranScreen benar
              metodePembayaran: _selectedPaymentMethod,
              totalHarga: widget.totalHarga,
              batasWaktuPembayaran: _batasWaktuPembayaran,
              kotaAsal: widget.kotaAsal,
              kotaTujuan: widget.kotaTujuan,
              tanggalKeberangkatan: widget.tanggalKeberangkatan,
              jadwalTerpilih: widget.jadwalTerpilih,
              jumlahPenumpang: widget.jumlahPenumpang,
            ),
      ),
    );
  }

  @override
  void dispose() {
    /* ... implementasi tetap ... */
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna sekarang dari app_colors.dart
    // ... (Sisa build method, semua penggunaan mainBlue, dll. akan merujuk ke app_colors.dart)
    String formattedBatasWaktu = DateFormat(
      'EEEE, dd MMMM finalList HH:mm:ss',
      'id_ID',
    ).format(_batasWaktuPembayaran);
    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentDeadlineCard(formattedBatasWaktu),
            const SizedBox(height: 16),
            _buildPromoCard(),
            const SizedBox(height: 24),
            Text(
              'METODE PEMBAYARAN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.directions_bus_filled,
              label: 'Bus Pay',
              method: MetodePembayaran.busPay,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.qr_code_scanner,
              label: 'Qris',
              method: MetodePembayaran.qris,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.account_balance,
              label: 'M-Banking',
              method: MetodePembayaran.mBanking,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _lanjutkanPembayaran,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                'Bayar IDR ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(widget.totalHarga)}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDeadlineCard(String formattedBatasWaktu) {
    /* ... implementasi tetap, warna dari app_colors.dart ... */
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: paymentDeadlineCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.alarm, color: Colors.blueGrey[700], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batas waktu pembayaran',
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedBatasWaktu,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    /* ... implementasi tetap, warna dari app_colors.dart ... */
    return Material(
      color: promoCardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur kode promo belum diimplementasi.'),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(Icons.sell_outlined, color: Colors.blueGrey[700], size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Masukkan kode promo/voucher',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueGrey[600],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required IconData icon,
    required String label,
    required MetodePembayaran method,
  }) {
    /* ... implementasi tetap, warna dari app_colors.dart ... */
    bool isSelected = _selectedPaymentMethod == method;
    return Material(
      color: isSelected ? mainBlue.withOpacity(0.2) : cardBgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _selectPaymentMethod(method),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? mainBlue : Colors.blueGrey[700],
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? mainBlue : Colors.blueGrey[800],
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: mainBlue, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
