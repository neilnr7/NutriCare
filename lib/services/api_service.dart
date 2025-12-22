import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  // ------------------------------
  // POST REQUEST
  // ------------------------------
  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");


    print("➡️ POST: $url");
    print("📦 DATA: $data");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
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
  // GET REQUEST (for profile fetch)
  // ------------------------------
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    print("➡️ GET: $url");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    print("⬅️ Response Code: ${response.statusCode}");
    print("⬅️ Response Body: ${response.body}");

    if (response.body.isEmpty) {
      return {"success": false, "error": "Empty response from server"};
    }

    return jsonDecode(response.body);
  }
}
