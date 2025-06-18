// lib/services/tiket_service_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bussgo/models/tiket_api_model.dart';
import 'package:bussgo/services/auth_service.dart';

class TiketServiceApi {
  static const _storage = FlutterSecureStorage();

  static Future<List<TiketFromApi>> getMyTickets() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Silakan login ulang.');

    final url = Uri.parse('${AuthService.baseUrl}/pemesanan/riwayat');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listTiketJson = data['data'];
        return listTiketJson
            .map((json) => TiketFromApi.fromJson(json))
            .toList();
      } else {
        throw Exception('Gagal memuat riwayat tiket.');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server.');
    }
  }
}
