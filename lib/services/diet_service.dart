import 'api_service.dart';

class DietService {
  // =======================================================
  // 1️⃣ DOCTOR — GET PATIENTS (FROM CHATS)
  // =======================================================
  static Future<List<Map<String, dynamic>>> getDoctorDietPatients() async {
    final response = await ApiService.get(
      "getDoctorDietPatients",
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(
        response["error"] ?? "Failed to load doctor diet patients",
      );
    }

    return List<Map<String, dynamic>>.from(response["patients"]);
  }

  // =======================================================
  // 2️⃣ DOCTOR — GET PATIENTS (FROM APPOINTMENTS)
  // =======================================================
  static Future<List<Map<String, dynamic>>>
  getDoctorPatientsFromAppointments() async {
    final response = await ApiService.get(
      "getDoctorPatientsFromAppointments",
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(
        response["error"] ??
            "Failed to load doctor patients from appointments",
      );
    }

    return List<Map<String, dynamic>>.from(response["patients"]);
  }

  // =======================================================
  // 3️⃣ DOCTOR — SAVE / UPDATE DIET PLAN
  // =======================================================
  static Future<void> saveDietPlan({
    required String patientId,
    required Map<String, Map<String, String>> weeklyDiet,
  }) async {
    final response = await ApiService.post(
      "saveDietPlan",
      {
        "patientId": patientId,
        "weeklyDiet": weeklyDiet,
      },
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(
        response["error"] ?? "Failed to save diet plan",
      );
    }
  }

  // =======================================================
  // 4️⃣ DOCTOR — GET DIET FOR SELECTED PATIENT
  // =======================================================
  static Future<Map<String, dynamic>?> getDietForDoctor({
    required String patientId,
  }) async {
    final response = await ApiService.get(
      "getDietForDoctor?patientId=$patientId",
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to load diet plan",);
    }

    return response; // NOT response["diet"]
  }


  // =======================================================
  // 5️⃣ PATIENT — GET MY DIET (READ ONLY)
  // =======================================================
  static Future<Map<String, dynamic>?> getDietForPatient() async {
    final response = await ApiService.get(
      "getDietForPatient",
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(response["error"] ?? "Failed to load patient diet",);
    }

    return response; // NOT response["diet"]
  }



  // =======================================================
  // 6️⃣ PATIENT — UPDATE DIET COMPLETION STATUS ✅ NEW
  // =======================================================
  static Future<void> updateDietStatus({
    required String day,
    required String slot,
    required bool completed,
  }) async {
    final response = await ApiService.post(
      "updateDietStatus",
      {
        "day": day,
        "slot": slot,
        "completed": completed,
      },
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(
        response["error"] ?? "Failed to update diet status",
      );
    }
  }


  // =======================================================
  // 7️⃣ DOCTOR / PATIENT — GET DIET COMPLETION STATUS ✅ NEW
  // =======================================================
  static Future<Map<String, dynamic>?> getDietStatus({
    String? patientId, // required for doctor, null for patient
  }) async {
    final endpoint = patientId == null
        ? "getDietStatus"
        : "getDietStatus?patientId=$patientId";

    final response = await ApiService.get(
      endpoint,
      requiresAuth: true,
    );

    if (response["success"] != true) {
      throw Exception(
        response["error"] ?? "Failed to load diet status",
      );
    }

    return response["weeklyStatus"];
  }
}
