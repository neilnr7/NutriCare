import 'api_service.dart';

class AppointmentService {
  // ======================================================
  // PATIENT — CREATE APPOINTMENT
  // ======================================================
  static Future createAppointment({
    required String doctorId,
    required String appointmentDate, // YYYY-MM-DD
    required String startTime, // HH:mm
    required String endTime,   // HH:mm
    String? reason,
    bool isRecurring = false,
    String recurrenceType = "none", // weekly / none
  }) {
    return ApiService.post(
      "createAppointment",
      {
        "doctorId": doctorId,
        "appointmentDate": appointmentDate,
        "startTime": startTime,
        "endTime": endTime,
        "reason": reason ?? "",
        "isRecurring": isRecurring,
        "recurrenceType": recurrenceType,
      },
      requiresAuth: true,
    );
  }

  // ======================================================
  // DOCTOR — GET APPOINTMENTS BY DATE
  // ======================================================
  static Future getDoctorAppointmentsByDate(String date) {
    return ApiService.get(
      "getDoctorAppointmentsByDate?date=$date",
      requiresAuth: true,
    );
  }


  // ======================================================
  // DOCTOR — UPDATE STATUS
  // approved | completed | cancelled
  // ======================================================
  static Future updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) {
    return ApiService.post(
      "updateAppointmentStatus",
      {
        "appointmentId": appointmentId,
        "status": status,
      },
      requiresAuth: true,
    );
  }

  // ======================================================
  // DOCTOR — ADD REPORT
  // ======================================================
  static Future addAppointmentReport({
    required String appointmentId,
    required String report,
  }) {
    return ApiService.post(
      "addAppointmentReport",
      {
        "appointmentId": appointmentId,
        "report": report,
      },
      requiresAuth: true,
    );
  }

  // ======================================================
  // DOCTOR — RESCHEDULE APPOINTMENT
  // ======================================================
  static Future rescheduleAppointment({
    required String appointmentId,
    required String newDate,
    required String newStartTime,
    required String newEndTime,
  }) {
    return ApiService.post(
      "rescheduleAppointment",
      {
        "appointmentId": appointmentId,
        "newDate": newDate,
        "newStartTime": newStartTime,
        "newEndTime": newEndTime,
      },
      requiresAuth: true,
    );
  }

  // ======================================================
// DOCTOR — GENERATE WEEKLY APPOINTMENT
// ======================================================
  static Future generateWeeklyAppointment({
    required String appointmentId,
  }) {
    return ApiService.post(
      "generateWeeklyAppointment",
      {
        "appointmentId": appointmentId,
      },
      requiresAuth: true,
    );
  }


  // ======================================================
  // DOCTOR — BLOCK CALENDAR
  // ======================================================
  static Future blockDoctorCalendar({
    required String date,
    required String startTime,
    required String endTime,
    String? reason,
  }) {
    return ApiService.post(
      "blockDoctorCalendar",
      {
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "reason": reason ?? "Doctor unavailable",
      },
      requiresAuth: true,
    );
  }

  // ======================================================
// PATIENT — GET UPCOMING APPOINTMENTS
// ======================================================
  static Future getPatientAppointments() {
    return ApiService.get(
      "getPatientAppointments",
      requiresAuth: true,
    );
  }

}
