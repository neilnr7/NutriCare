import 'api_service.dart';

class PatientService {
  // ------------------------------
  // PUBLIC (NO TOKEN)
  // ------------------------------
  static Future sendOtp(String email) async {
    return ApiService.post(
      "sendEmailOTP",
      {"email": email},
      requiresAuth: false,
    );
  }

  static Future verifyOtp(
      String email,
      String otp,
      String newPassword,
      ) async {
    return ApiService.post(
      "verifyEmailOTP",
      {
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
      },
      requiresAuth: false,
    );
  }

  static Future registerPatient({
    required String firstName,
    String? middleName,
    String? lastName,
    required String phone,
    required String email,
    required String gender,
    required String password,
  }) async {
    return ApiService.post(
      "registerPatient",
      {
        "firstName": firstName,
        "middleName": middleName ?? "",
        "lastName": lastName ?? "",
        "phone": phone,
        "email": email,
        "gender": gender,
        "password": password,
      },
      requiresAuth: false,
    );
  }

  static Future loginPatient(String phone, String password) async {
    return ApiService.post(
      "loginPatient",
      {
        "phone": phone,
        "password": password,
      },
      requiresAuth: false,
    );
  }

  // ------------------------------
  // PROTECTED (TOKEN REQUIRED)
  // ------------------------------
  static Future getProfile(String uid) async {
    return ApiService.get("getPatientProfile?uid=$uid");
  }

  static Future updateProfile({
    required String uid,
    required String dob,
    required String address,
    required int age,
    String? profilePicture,
    List<String>? healthRecords,
  }) async {
    return ApiService.post("updatePatientProfile", {
      "uid": uid,
      "dob": dob,
      "address": address,
      "age": age,
      "profilePicture": profilePicture,
      "healthRecords": healthRecords ?? [],
    });
  }
}
