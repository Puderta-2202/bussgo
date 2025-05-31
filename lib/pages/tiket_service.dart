import 'dart:math';
import 'tiket_saya.dart' show Tiket;

class TicketService {
  // List static untuk menyimpan tiket yang dibeli (simulasi database)
  static final List<Tiket> _purchasedTickets = [];

  // Mengambil semua tiket yang sudah dibeli
  static List<Tiket> getPurchasedTickets() {
    // Mengembalikan salinan list agar list asli tidak bisa dimodifikasi dari luar
    return List.from(
      _purchasedTickets.reversed,
    ); // Tampilkan yang terbaru di atas
  }

  // Menambahkan tiket baru ke daftar
  static void addPurchasedTicket(Tiket ticket) {
    _purchasedTickets.add(ticket);
    // Di aplikasi nyata, ini akan proses menyimpan ke database.
    // Anda mungkin juga ingin menambahkan logika untuk mencegah duplikasi jika perlu.
  }

  // Helper untuk generate ID booking dummy yang lebih unik
  static String generateBookingId() {
    var random = Random();
    // Kombinasi timestamp dan angka acak untuk membuatnya lebih unik
    String timestampPart = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);
    String randomPart = (random.nextInt(9000) + 1000).toString();
    return "BUSGO-$timestampPart-$randomPart";
  }

  static void clearAllTickets() {
    _purchasedTickets.clear();
  }
}
