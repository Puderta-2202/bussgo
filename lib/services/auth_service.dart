import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://Busgo.my.id/api';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String noHandphone,
    required String alamat,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'nama_lengkap': name,
        'email': email,
        'no_handphone': noHandphone,
        'alamat': alamat,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) return responseData;
    throw Exception(responseData['message'] ?? 'Gagal registrasi.');
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      await _storage.write(
        key: 'auth_token',
        value: responseData['access_token'],
      );
      return responseData;
    }
    throw Exception(responseData['message'] ?? 'Gagal login.');
  }

  static Future<void> logout() async {
    String? token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('$baseUrl/logout');
    try {
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } finally {
      await _storage.delete(key: 'auth_token');
    }
  }

  static Future<Map<String, dynamic>> getAuthenticatedUser() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Token tidak ditemukan.');
    final url = Uri.parse('$baseUrl/user');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Gagal memuat data pengguna.');
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception('Silakan login ulang.');

    final url = Uri.parse('$baseUrl/user/change-password');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Gagal mengubah password.');
    }
  }

  static Future<String> forgotPassword({required String email}) async {
    final url = Uri.parse('$baseUrl/password/forgot');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'email': email},
    );
    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Gagal mengirim permintaan.');
    }
    return data['message'];
  }
}
