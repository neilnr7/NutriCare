import 'api_service.dart';

class DoctorService {
  // ------------------------------
  // PUBLIC (NO TOKEN)
  // ------------------------------
  static Future sendOtp(String email) async {
    return ApiService.post(
      "sendDoctorEmailOTP",
      {"email": email},
      requiresAuth: false,
    );
  }

  static Future verifyOtp(String email, String otp, String newPassword) async {
    return ApiService.post(
      "verifyDoctorEmailOTP",
      {
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
      },
      requiresAuth: false,
    );
  }

  static Future registerDoctor({
    required String firstName,
    String? middleName,
    String? lastName,
    required String phone,
    required String email,
    required String gender,
    required String password,
    required String specialisation,
  }) async {
    return ApiService.post(
      "registerDoctor",
      {
        "firstName": firstName,
        "middleName": middleName ?? "",
        "lastName": lastName ?? "",
        "phone": phone,
        "email": email,
        "gender": gender,
        "password": password,
        "specialisation": specialisation,
      },
      requiresAuth: false,
    );
  }

  static Future loginDoctor(String phone, String password) async {
    return ApiService.post(
      "loginDoctor",
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
  static Future updateProfile({
    required String uid,
    required String dob,
    required String address,
    required int age,
    String? profilePicture,
  }) async {
    return ApiService.post("updateDoctorProfile", {
      "uid": uid,
      "dob": dob,
      "address": address,
      "age": age,
      "profilePicture": profilePicture,
    });
  }

  static Future getProfile(String uid) async {
    return ApiService.get("getDoctorProfile?uid=$uid");
  }

  // ✅ PUBLIC ENDPOINT — NO TOKEN
  static Future getDoctors() {
    return ApiService.get(
      "getDoctors",
      requiresAuth: false,
    );
  }
}
