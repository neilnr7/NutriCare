import 'api_service.dart';

class ChatService {
  // =======================================================
  // 1️⃣ CREATE OR GET CHAT
  // =======================================================
  static Future<String> createOrGetChat({
    required String doctorId,
    required String patientId,
  }) async {
    final response = await ApiService.post(
      "createOrGetChat",
      {
        "doctorId": doctorId,
        "patientId": patientId,
      },
    );

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to create/get chat");
    }

    return response["chatId"];
  }

  // =======================================================
  // 2️⃣ SEND MESSAGE
  // =======================================================
  static Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final response = await ApiService.post(
      "sendMessage",
      {
        "chatId": chatId,
        "text": text,
      },
    );

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to send message");
    }
  }

  // =======================================================
  // 3️⃣ GET MESSAGES
  // =======================================================
  static Future<List<Map<String, dynamic>>> getMessages(
      String chatId) async {
    final response =
    await ApiService.get("getMessages?chatId=$chatId");

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to load messages");
    }

    return List<Map<String, dynamic>>.from(response["messages"]);
  }

  // =======================================================
  // 4️⃣ GET DOCTOR CHATS
  // =======================================================
  static Future<List<Map<String, dynamic>>> getDoctorChats() async {
    final response = await ApiService.get("getDoctorChats");

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to load doctor chats");
    }

    return List<Map<String, dynamic>>.from(response["chats"]);
  }

  // =======================================================
  // 5️⃣ GET PATIENT CHATS
  // =======================================================
  static Future<List<Map<String, dynamic>>> getPatientChats() async {
    final response = await ApiService.get("getPatientChats");

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to load patient chats");
    }

    return List<Map<String, dynamic>>.from(response["chats"]);
  }

  // =======================================================
  // 6️⃣ MARK CHAT AS READ
  // =======================================================
  static Future<void> markChatAsRead(String chatId) async {
    final response = await ApiService.post(
      "markChatAsRead",
      {
        "chatId": chatId,
      },
    );

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to mark chat as read");
    }
  }
}
