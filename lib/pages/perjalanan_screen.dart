import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bussgo/services/pemesanan_service.dart';
import 'pembayaran.dart';
// import 'jadwalkeberangkatan.dart';
import 'app_color.dart';
import 'package:bussgo/enum/metode_pembayaran.dart';
import 'package:bussgo/models/jadwal_from_api.dart';

class PilihPembayaranScreen extends StatefulWidget {
  // --- PASTIKAN KONSTRUKTOR MENERIMA SEMUA DATA INI ---
  final int totalHarga;
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final JadwalFromApi jadwalTerpilih;
  final int jumlahPenumpang;
  final List<String> kursiPilihan;
  final Map<String, dynamic> currentUser;

  const PilihPembayaranScreen({
    Key? key,
    required this.totalHarga,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jadwalTerpilih,
    required this.jumlahPenumpang,
    required this.kursiPilihan,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<PilihPembayaranScreen> createState() => _PilihPembayaranScreenState();
}

class _PilihPembayaranScreenState extends State<PilihPembayaranScreen> {
  MetodePembayaran _selectedPaymentMethod = MetodePembayaran.none;
  bool _isLoading = false;
  // Kita tidak perlu state _currentUser lagi karena sudah diterima dari widget

  @override
  void initState() {
    super.initState();
    // Tidak perlu lagi fetch user karena data sudah diterima
  }

  void _selectPaymentMethod(MetodePembayaran method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _prosesPemesanan() async {
    if (_selectedPaymentMethod == MetodePembayaran.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final pemesananData = await PemesananService.buatPemesananAwal(
        keberangkatanId: widget.jadwalTerpilih.id,
        jumlahTiket: widget.jumlahPenumpang,
        nomorKursi: widget.kursiPilihan,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => KonfirmasiPembayaranScreen(
                metodePembayaran: _selectedPaymentMethod,
                pemesananId: pemesananData['id_pemesanan'],
                totalHarga: pemesananData['total_harga'],
                kodeBooking: pemesananData['kode_booking'],
                saldoAwal:
                    double.tryParse(
                      widget.currentUser['saldo']?.toString() ?? '0',
                    ) ??
                    0,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
        title: const Text(
          'Pilih Pembayaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRingkas(),
            const SizedBox(height: 24),
            Text(
              'METODE PEMBAYARAN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.account_balance_wallet_outlined,
              label: 'BusPay',
              method: MetodePembayaran.busPay,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.qr_code_scanner,
              label: 'QRIS',
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
              onPressed: _isLoading ? null : _prosesPemesanan,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        'Lanjutkan Pembayaran (Rp ${NumberFormat.decimalPattern('id').format(widget.totalHarga)})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRingkas() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.kotaAsal,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
              ),
              Text(
                widget.kotaTujuan,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.jumlahPenumpang} Penumpang',
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                widget.kursiPilihan.join(', '),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required IconData icon,
    required String label,
    required MetodePembayaran method,
  }) {
    bool isSelected = _selectedPaymentMethod == method;
    return Material(
      color: isSelected ? mainBlue.withOpacity(0.15) : cardBgColor,
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
                const Icon(Icons.check_circle, color: mainBlue, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
