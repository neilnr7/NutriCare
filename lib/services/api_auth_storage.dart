import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiAuthStorage {
  static const _storage = FlutterSecureStorage();

  // ---------- SAVE ----------
  static Future<void> saveAuthData({
    required String token,
    required String uid,
    required String role, // doctor / patient
  }) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_uid', value: uid);
    await _storage.write(key: 'user_role', value: role);
  }

  // ---------- READ ----------
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<String?> getUid() async {
    return await _storage.read(key: 'user_uid');
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }

  // ---------- CLEAR ----------
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
