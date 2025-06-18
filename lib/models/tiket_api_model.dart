// lib/models/api/tiket_api_model.dart
class TiketFromApi {
  final int id;
  final String kodeBooking;
  final String namaPemesan;
  final int jumlahTiket;
  final int totalHarga;
  final String statusPembayaran;
  final String metodePembayaran;
  final String tanggalPemesanan;
  final List<String> nomorKursi;
  final Map<String, dynamic> jadwalKeberangkatan;

  TiketFromApi({
    required this.id,
    required this.kodeBooking,
    required this.namaPemesan,
    required this.jumlahTiket,
    required this.totalHarga,
    required this.statusPembayaran,
    required this.metodePembayaran,
    required this.tanggalPemesanan,
    required this.nomorKursi,
    required this.jadwalKeberangkatan,
  });

  factory TiketFromApi.fromJson(Map<String, dynamic> json) {
    return TiketFromApi(
      id: json['id_pemesanan'] ?? 0, // <-- SUDAH DIPERBAIKI
      kodeBooking: json['kode_booking'] ?? 'N/A',
      namaPemesan: json['nama_pemesan'] ?? 'N/A',
      jumlahTiket: json['jumlah_tiket'] ?? 0,
      totalHarga: json['total_harga'] ?? 0,
      statusPembayaran: json['status_pembayaran'] ?? 'pending',
      metodePembayaran: json['metode_pembayaran'] ?? 'N/A',
      tanggalPemesanan:
          json['tanggal_pemesanan'] ??
          '', // Menggunakan 'tanggal_pemesanan' dari API
      nomorKursi: List<String>.from(json['nomor_kursi_dipesan'] ?? []),
      jadwalKeberangkatan: json['jadwal_keberangkatan'] ?? {},
    );
  }
}
