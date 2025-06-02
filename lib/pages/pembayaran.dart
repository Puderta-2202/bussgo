import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'perjalanan_screen.dart';
import 'jadwalkeberangkatan.dart' show JadwalKeberangkatanModel;
import 'home_screen.dart';
import 'app_color.dart';
import 'tiket_service.dart';
import 'tiket_saya.dart'
    show Tiket, TiketSayaPage; // Model Tiket dari tiket_saya.dart

class KonfirmasiPembayaranScreen extends StatelessWidget {
  final MetodePembayaran metodePembayaran;
  final int totalHarga;
  final DateTime batasWaktuPembayaran;
  final String kotaAsal;
  final String kotaTujuan;
  final DateTime tanggalKeberangkatan;
  final JadwalKeberangkatanModel jadwalTerpilih;
  final int jumlahPenumpang;

  const KonfirmasiPembayaranScreen({
    Key? key,
    required this.metodePembayaran,
    required this.totalHarga,
    required this.batasWaktuPembayaran,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalKeberangkatan,
    required this.jadwalTerpilih,
    required this.jumlahPenumpang,
  }) : super(key: key);

  int _parseHarga(String hargaString) {
    String numericString = hargaString.replaceAll(
      RegExp(r'K', caseSensitive: false),
      '000',
    );
    numericString = numericString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString) ?? 0;
  }

  // Fungsi untuk membuat dan menyimpan tiket
  void _prosesPembelianSelesai(BuildContext context) {
    String bookingId = TicketService.generateBookingId();
    String formattedTanggal = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(tanggalKeberangkatan);
    String waktuKeberangkatanDisplay =
        "${jadwalTerpilih.waktuBerangkat} - ${jadwalTerpilih.waktuSampai}";
    // Harga di model Tiket bisa jadi harga total atau harga per tiket, sesuaikan
    String hargaDisplay = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);

    // Membuat detail nomor kursi (contoh sederhana)
    String nomorKursiDisplay = "$jumlahPenumpang Kursi";
    // Jika Anda menyimpan detail kursi yang dipilih (misalnya dari _detailKursiTerpilih di HomeScreen),
    // Anda bisa meneruskannya sampai sini dan memformatnya.
    // Contoh: nomorKursiDisplay = detailKursiYangDipilih.join(', ');

    Tiket tiketBaru = Tiket(
      id: bookingId,
      jenisTiket:
          'Tiket ${jadwalTerpilih.namaBus}', // atau jenis tiket yang lebih spesifik
      tanggalKeberangkatan: formattedTanggal,
      waktuKeberangkatan: waktuKeberangkatanDisplay,
      kotaAsal: kotaAsal,
      kotaTujuan: kotaTujuan,
      namaBus: jadwalTerpilih.namaBus,
      nomorKursi: nomorKursiDisplay, // Bisa lebih detail jika ada data kursi
      harga: hargaDisplay, // Ini total harga
    );

    TicketService.addPurchasedTicket(tiketBaru);

    // Navigasi ke halaman Tiket Saya setelah tiket ditambahkan
    // Menggunakan pushAndRemoveUntil agar pengguna tidak bisa kembali ke halaman pembayaran
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const TiketSayaPage(),
      ), // TiketSayaPage akan load dari TicketService
      (route) => false, // Hapus semua rute sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "Konfirmasi Pembayaran";
    Widget bodyContent;

    switch (metodePembayaran) {
      case MetodePembayaran.qris:
        appBarTitle = "Qris";
        bodyContent = _buildQrisContent(context);
        break;
      case MetodePembayaran.mBanking:
        appBarTitle = "M-Banking";
        bodyContent = _buildMBankingContent(context);
        break;
      case MetodePembayaran.busPay:
        appBarTitle = "Bus Pay";
        bodyContent = _buildBusPayContent(context);
        break;
      default:
        bodyContent = const Center(
          child: Text("Metode pembayaran tidak valid."),
        );
    }

    return Scaffold(
      backgroundColor: screenBgLightBlue,
      appBar: AppBar(
        backgroundColor: mainBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: bodyContent,
      ),
    );
  }

  Widget _buildQrisContent(BuildContext context) {
    // ... (UI QRIS tetap sama)
    // Tambahkan tombol "Saya Sudah Bayar" yang memanggil _prosesPembelianSelesai
    String formattedBatasWaktu = DateFormat(
      'EEEE, dd MMMM HH:mm:ss',
      'id_ID',
    ).format(batasWaktuPembayaran);
    String formattedTanggalPerjalanan = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(tanggalKeberangkatan);
    String waktuPerjalanan =
        "${jadwalTerpilih.waktuBerangkat} - ${jadwalTerpilih.waktuSampai}";
    String paymentCode = "100498673549808";
    int hargaSatuan = _parseHarga(jadwalTerpilih.harga);
    String formattedHargaSatuan = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(hargaSatuan);
    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);
    return Column(
      children: [
        _buildInfoCard(
          child: Text(
            "Batas waktu pembayaran\n$formattedBatasWaktu",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          child: Column(
            children: [
              Text(
                "$formattedTanggalPerjalanan     $waktuPerjalanan",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(kotaAsal, style: const TextStyle(fontSize: 14)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 16),
                  ),
                  Text(kotaTujuan, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/qris_logo.png',
                    height: 20,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.payment, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Payment Code",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                paymentCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Harga",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Penumpang"),
                  Text("$jumlahPenumpang x $formattedHargaSatuan"),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Harga",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formattedTotalHarga,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: mainBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          child: Column(
            children: [
              Image.asset(
                'assets/images/qris_logo.png',
                height: 30,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.qr_code_scanner_rounded, size: 30),
              ),
              const SizedBox(height: 4),
              const Text(
                "BUSGO SUMATERA UTARA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                paymentCode,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              QrImageView(
                data: paymentCode,
                version: QrVersions.auto,
                size: 180.0,
                gapless: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _prosesPembelianSelesai(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: mainBlue,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            "Saya Sudah Bayar / Konfirmasi",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildMBankingContent(BuildContext context) {
    // ... (UI M-Banking tetap sama)
    // Modifikasi tombol "Saya Sudah Bayar / Selesai" untuk memanggil _prosesPembelianSelesai
    String formattedBatasWaktu = DateFormat(
      'EEEE, dd MMMM HH:mm:ss',
      'id_ID',
    ).format(batasWaktuPembayaran);
    String virtualAccountNumber =
        "8808 ${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}";
    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          child: Text(
            "Batas waktu pembayaran\n$formattedBatasWaktu",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Instruksi Pembayaran M-Banking",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Silakan lakukan pembayaran ke nomor Virtual Account berikut:",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  virtualAccountNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Total Pembayaran: $formattedTotalHarga",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: mainBlue,
                  ),
                ),
              ),
              const Divider(height: 24, thickness: 1),
              const Text(
                "Langkah-langkah pembayaran:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text("1. Login ke aplikasi M-Banking Anda."),
              const Text("2. Pilih menu Transfer, lalu pilih Virtual Account."),
              const Text("3. Masukkan nomor Virtual Account di atas."),
              const Text("4. Masukkan jumlah pembayaran sesuai total di atas."),
              const Text(
                "5. Ikuti instruksi selanjutnya untuk menyelesaikan pembayaran.",
              ),
              const SizedBox(height: 10),
              const Text(
                "Pastikan Anda melakukan pembayaran sebelum batas waktu.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () => _prosesPembelianSelesai(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text(
              "Saya Sudah Bayar / Konfirmasi",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusPayContent(BuildContext context) {
    double saldoAwalNumerik = HomeScreenState.numericalBusPayBalance;
    double saldoAkhirNumerik = saldoAwalNumerik - totalHarga;

    // Panggil _prosesPembelianSelesai setelah update saldo
    // Ini akan terjadi sebelum widget ini di-build sepenuhnya, jadi kita panggil di sini
    // atau lebih baik, panggil di onPressed tombol "Selesai"
    // HomeScreenState.updateAndFormatBusPayBalance(saldoAkhirNumerik); // Pindahkan ini ke onPressed

    String formattedTotalHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    ).format(totalHarga);
    // Untuk menampilkan sisa saldo, kita ambil dari HomeScreenState setelah update
    // String formattedSisaSaldo = HomeScreenState.busPayBalanceString; // Akan diupdate setelah tombol ditekan

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green[600],
          size: 80,
        ),
        const SizedBox(height: 20),
        const Text(
          "Pembayaran Diproses...",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          child: Column(
            children: [
              Text(
                "Pembayaran dengan Bus Pay sebesar $formattedTotalHarga sedang diproses.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Tampilkan saldo awal, atau pesan bahwa saldo akan diupdate
              Text(
                "Saldo Bus Pay Anda akan segera diperbarui.",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Lakukan update saldo SEKARANG, lalu proses pembelian selesai
            HomeScreenState.updateAndFormatBusPayBalance(saldoAkhirNumerik);
            _prosesPembelianSelesai(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: mainBlue,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            "Konfirmasi & Lihat Tiket",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
