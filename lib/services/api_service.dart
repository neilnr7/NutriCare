import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  // ------------------------------
  // POST REQUEST (AUTH + PUBLIC)
  // ------------------------------
  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final headers = requiresAuth
        ? await ApiConfig.authHeaders()
        : ApiConfig.publicHeaders();

    print("➡️ POST: $url");
    print("📦 DATA: $data");
    print("🧾 HEADERS: $headers");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    print("⬅️ Response Code: ${response.statusCode}");
    print("⬅️ Response Body: ${response.body}");

    if (response.body.isEmpty) {
      return {"success": false, "error": "Empty response from server"};
    }

    return jsonDecode(response.body);
  }

  // ------------------------------
  // GET REQUEST (AUTH + PUBLIC)
  // ------------------------------
  static Future<Map<String, dynamic>> get(
      String endpoint, {
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final headers = requiresAuth
        ? await ApiConfig.authHeaders()
        : ApiConfig.publicHeaders();

    print("➡️ GET: $url");
    print("🧾 HEADERS: $headers");

    final response = await http.get(
      url,
      headers: headers,
    );

    print("⬅️ Response Code: ${response.statusCode}");
    print("⬅️ Response Body: ${response.body}");

    if (response.body.isEmpty) {
      return {"success": false, "error": "Empty response from server"};
    }

    return jsonDecode(response.body);
  }
}
