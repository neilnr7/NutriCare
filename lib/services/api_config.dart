import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  static const String baseUrl =
      "http://192.168.1.5:5001/demo-no-project/us-central1/";

  static const _storage = FlutterSecureStorage();

  // 🔹 SAVE AUTH TOKEN (CALL AFTER LOGIN)
  static Future<void> setAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // 🔹 CLEAR TOKEN (OPTIONAL — LOGOUT)
  static Future<void> clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// 🔐 Get Authorization headers
  static Future<Map<String, String>> authHeaders() async {
    final token = await _storage.read(key: 'auth_token');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// 🌐 Headers without auth (signup / login)
  static Map<String, String> publicHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }
}
