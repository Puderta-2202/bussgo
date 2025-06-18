// lib/services/pemesanan_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bussgo/services/auth_service.dart';

class PemesananService {
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> buatPemesananAwal({
    required int keberangkatanId,
    required int jumlahTiket,
    required List<String> nomorKursi,
  }) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Silakan login ulang.');

    final url = Uri.parse('${AuthService.baseUrl}/pemesanan');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'keberangkatan_id': keberangkatanId,
        'jumlah_tiket': jumlahTiket,
        'nomor_kursi_dipesan': nomorKursi,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      return responseData['data'];
    } else {
      throw Exception(responseData['message'] ?? 'Gagal membuat pemesanan.');
    }
  }
}
