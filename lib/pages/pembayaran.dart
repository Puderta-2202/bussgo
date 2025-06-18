import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bussgo/services/pembayaran_service.dart';
import 'app_color.dart';
import 'home_screen.dart';
import 'tiket_saya.dart';
import 'package:bussgo/enum/metode_pembayaran.dart';

class KonfirmasiPembayaranScreen extends StatefulWidget {
  final MetodePembayaran metodePembayaran;
  final int pemesananId;
  final int totalHarga;
  final String kodeBooking;
  final double saldoAwal;

  const KonfirmasiPembayaranScreen({
    Key? key,
    required this.metodePembayaran,
    required this.pemesananId,
    required this.totalHarga,
    required this.kodeBooking,
    required this.saldoAwal,
  }) : super(key: key);

  @override
  State<KonfirmasiPembayaranScreen> createState() =>
      _KonfirmasiPembayaranScreenState();
}

class _KonfirmasiPembayaranScreenState
    extends State<KonfirmasiPembayaranScreen> {
  bool _isLoading = false;

  void _prosesPembayaranSaldo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await PembayaranService.bayarDenganSaldo(widget.pemesananId);
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
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
    String appBarTitle;
    Widget bodyContent;

    switch (widget.metodePembayaran) {
      case MetodePembayaran.qris:
        appBarTitle = "Pembayaran QRIS";
        bodyContent = _buildQrisContent(context);
        break;
      case MetodePembayaran.mBanking:
        appBarTitle = "Pembayaran M-Banking";
        bodyContent = _buildMBankingContent(context);
        break;
      case MetodePembayaran.busPay:
        appBarTitle = "Konfirmasi BusPay";
        bodyContent = _buildBusPayContent(context);
        break;
      default:
        appBarTitle = "Error";
        bodyContent = const Center(
          child: Text("Metode pembayaran tidak valid."),
        );
    }

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: bodyContent,
      ),
    );
  }

  Widget _buildBusPayContent(BuildContext context) {
    bool bisaBayar = widget.saldoAwal >= widget.totalHarga;
    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.totalHarga);
    String formattedSaldoAwal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.saldoAwal);
    String formattedSisaSaldo = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.saldoAwal - widget.totalHarga);

    return Column(
      children: [
        _buildInfoCard(
          title: 'Konfirmasi Pembayaran Saldo',
          child: Column(
            children: [
              _buildInfoRow('Total Tagihan', formattedTotalHarga),
              _buildInfoRow('Saldo BusPay Anda', formattedSaldoAwal),
              const Divider(height: 20, thickness: 1, color: Colors.black12),
              _buildInfoRow(
                'Sisa Saldo Setelah Bayar',
                formattedSisaSaldo,
                isBold: true,
                valueColor: mainBlue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (!bisaBayar)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Saldo BusPay Anda tidak mencukupi. Silakan lakukan Top Up terlebih dahulu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _prosesPembayaranSaldo,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : const Text(
                        'Konfirmasi & Bayar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
            ),
          ),
      ],
    );
  }

  Widget _buildQrisContent(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Scan QRIS untuk Membayar',
          child: Center(
            child: QrImageView(
              data: widget.kodeBooking,
              version: QrVersions.auto,
              size: 220.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Buka aplikasi pembayaran Anda dan scan QRIS di atas. Status tiket akan diperbarui secara otomatis setelah pembayaran berhasil.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget _buildMBankingContent(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Instruksi M-Banking',
          child: Column(
            children: [
              const Text(
                "Silakan lakukan transfer ke nomor Virtual Account di bawah ini:",
              ),
              const SizedBox(height: 12),
              SelectableText(
                "8808${widget.pemesananId.toString().padLeft(8, '0')}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(widget.totalHarga),
                style: const TextStyle(
                  fontSize: 18,
                  color: mainBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Status tiket akan diperbarui secara otomatis oleh sistem setelah Anda berhasil transfer.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget _buildInfoCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Pembayaran Berhasil'),
              ],
            ),
            content: Text(
              'Tiket Anda untuk kode booking ${widget.kodeBooking} telah berhasil diterbitkan.',
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: mainBlue),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TiketSayaPage(),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Tiket Saya',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
