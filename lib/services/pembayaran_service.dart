import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bussgo/services/auth_service.dart';

class PembayaranService {
  static const _storage = FlutterSecureStorage();

  // Fungsi untuk memproses pembayaran dengan saldo
  static Future<void> bayarDenganSaldo(int pemesananId) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Silakan login ulang.');

    // Panggil endpoint API yang sudah kita siapkan di Laravel
    final url = Uri.parse(
      '${AuthService.baseUrl}/pemesanan/bayar-dengan-saldo',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'pemesanan_id': pemesananId.toString()},
      );

      // Jika server memberikan respons selain 200 (OK), anggap sebagai error
      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        // Lemparkan pesan error dari server
        throw Exception(
          responseData['message'] ?? 'Gagal memproses pembayaran.',
        );
      }
      // Jika sukses, tidak perlu mengembalikan apa-apa
    } catch (e) {
      // Tangani error koneksi atau error yang dilempar dari atas
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
