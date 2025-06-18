import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bussgo/services/auth_service.dart';

class TopUpService {
  static const _storage = FlutterSecureStorage();

  static Future<void> requestTopUp({required String amount}) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Silakan login ulang.');

    final url = Uri.parse('${AuthService.baseUrl}/topup/request');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'amount': amount}, // Kirim jumlahnya saja
      );

      if (response.statusCode != 201) {
        final responseData = json.decode(response.body);
        throw Exception(
          responseData['message'] ?? 'Gagal mengirim permintaan top up.',
        );
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server.${e.toString()}');
    }
  }
}
