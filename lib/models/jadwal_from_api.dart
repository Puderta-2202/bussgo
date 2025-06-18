// lib/models/jadwal_from_api.dart

class JadwalFromApi {
  final int id;
  final String asal;
  final String tujuan;
  final String tanggalBerangkat;
  final String jamBerangkat;
  final String jamSampai;
  final String durasiPerjalanan;
  final int harga;
  final int kursiTersedia;
  final Map<String, dynamic> bus;

  JadwalFromApi({
    required this.id,
    required this.asal,
    required this.tujuan,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.jamSampai,
    required this.durasiPerjalanan,
    required this.harga,
    required this.kursiTersedia,
    required this.bus,
  });

  factory JadwalFromApi.fromJson(Map<String, dynamic> json) {
    return JadwalFromApi(
      id: json['id'] ?? 0,
      asal: json['asal'] ?? '',
      tujuan: json['tujuan'] ?? '',
      tanggalBerangkat: json['tanggal_berangkat'] ?? '',
      jamBerangkat: json['jam_berangkat'] ?? '',
      jamSampai: json['jam_sampai'] ?? '',
      durasiPerjalanan: json['durasi_perjalanan'] ?? '',
      harga: json['harga'] ?? 0,
      kursiTersedia: json['kursi_tersedia'] ?? 0,
      bus: json['bus'] ?? {},
    );
  }
}
