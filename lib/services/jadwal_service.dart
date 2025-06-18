import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bussgo/services/auth_service.dart';
// import 'package:bussgo/pages/jadwalkeberangkatan.dart';
import 'package:bussgo/models/jadwal_from_api.dart';

class JadwalService {
  static const _storage = FlutterSecureStorage();
  // Ganti tipe kembalian fungsi menjadi Future<List<JadwalFromApi>>
  static Future<List<JadwalFromApi>> cariJadwal({
    required String asal,
    required String tujuan,
    required String tanggal,
  }) async {
    final url = Uri.parse(AuthService.baseUrl).replace(
      path: '/api/jadwal-keberangkatan',
      queryParameters: {'asal': asal, 'tujuan': tujuan, 'tanggal': tanggal},
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listJadwalJson = data['data'];

        // --- INI BAGIAN PENTINGNYA ---
        // Ubah setiap item di dalam list JSON menjadi objek JadwalFromApi
        return listJadwalJson
            .map((json) => JadwalFromApi.fromJson(json))
            .toList();
      } else {
        throw Exception('Gagal memuat data jadwal.');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server.');
    }
  }

  static Future<JadwalFromApi> getJadwalDetail(int id) async {
    final url = Uri.parse('${AuthService.baseUrl}/jadwal-keberangkatan/$id');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Mengubah JSON menjadi satu objek JadwalFromApi
        return JadwalFromApi.fromJson(data['data']);
      } else {
        throw Exception('Gagal memuat detail jadwal.');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server.');
    }
  }

  static Future<List<String>> getKursiTerisi(int jadwalId) async {
    // 1. Baca token dari penyimpanan
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final url = Uri.parse(
      '${AuthService.baseUrl}/jadwal-keberangkatan/$jadwalId/kursi-terisi',
    );

    try {
      final response = await http.get(
        url,
        // 2. Sertakan token di header Authorization
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['data']);
      } else {
        // Jika token tidak valid, server akan merespons 401
        throw Exception('Gagal memuat data kursi terisi.');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server.');
    }
  }
}
