import 'package:flutter/material.dart';

class PatientSummary {
  final String name;
  final bool isMale;

  const PatientSummary({
    required this.name,
    required this.isMale,
  });
}

enum AppointmentStatus { upcoming, completed, cancelled }

class Appointment {
  final String patientName;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final bool isMale;

  Appointment({
    required this.patientName,
    required this.date,
    required this.time,
    required this.status,
    required this.isMale,
  });
}

// helpers shared across files

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
