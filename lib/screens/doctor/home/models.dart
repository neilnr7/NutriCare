import 'package:flutter/material.dart';

// ======================================================
// PATIENT SUMMARY (HORIZONTAL LIST)
// ======================================================
class PatientSummary {
  final String uid;
  final String name;
  final bool isMale;

  const PatientSummary({
    required this.uid,
    required this.name,
    required this.isMale,
  });
}

// ======================================================
// APPOINTMENT STATUS (MATCHES BACKEND)
// ======================================================
enum AppointmentStatus {
  requested,
  approved,
  completed,
  cancelled,
  rescheduled,
  blocked,
}

// ======================================================
// APPOINTMENT MODEL (MATCHES FIRESTORE)
// ======================================================
class Appointment {
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String? patientName; // ✅ ADD


  final DateTime appointmentDate;
  final String startTime;
  final String endTime;

  final AppointmentStatus status;
  final String reason;

  final bool isRecurring;
  final String recurrenceType;

  final String? parentAppointmentId;
  final String? rescheduledTo;

  final Map<String, dynamic>? report;

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    this.patientName, // ✅ ADD
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reason,
    required this.isRecurring,
    required this.recurrenceType,
    this.parentAppointmentId,
    this.rescheduledTo,
    this.report,
  });

  // ======================================================
  // FACTORY — FIRESTORE → MODEL
  // ======================================================
  factory Appointment.fromMap(Map<String, dynamic> data) {
    return Appointment(
      appointmentId: data['appointmentId'],
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      patientName: data['patientName'], // ✅ ADD
      appointmentDate: DateTime.parse(data['appointmentDate']),
      startTime: data['startTime'],
      endTime: data['endTime'],
      status: _parseStatus(data['status']),
      reason: data['reason'] ?? '',
      isRecurring: data['isRecurring'] ?? false,
      recurrenceType: data['recurrenceType'] ?? 'none',
      parentAppointmentId: data['parentAppointmentId'],
      rescheduledTo: data['rescheduledTo'],
      report: data['report'],
    );
  }

  // ======================================================
  // HELPERS
  // ======================================================
  static AppointmentStatus _parseStatus(String value) {
    switch (value) {
      case 'requested':
        return AppointmentStatus.requested;
      case 'approved':
        return AppointmentStatus.approved;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      case 'blocked':
        return AppointmentStatus.blocked;
      default:
        return AppointmentStatus.requested;
    }
  }
}

// ======================================================
// SHARED HELPERS
// ======================================================
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
