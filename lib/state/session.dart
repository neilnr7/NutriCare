import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  static String? uid;

  static const _storage = FlutterSecureStorage();

  // ------------------------------
  // SAVE TOKEN AFTER LOGIN
  // ------------------------------
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // ------------------------------
  // GET TOKEN (USED BY ApiConfig)
  // ------------------------------
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // ------------------------------
  // CLEAR SESSION (LOGOUT)
  // ------------------------------
  static Future<void> clear() async {
    uid = null;
    await _storage.delete(key: 'auth_token');
  }
}
