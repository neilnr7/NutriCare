import 'package:flutter/material.dart';

import 'models.dart';
import 'doctor_calendar_card.dart';
import 'doctor_day_appointments_screen.dart';
import 'widgets/appointment_card.dart';
import 'widgets/doctor_patient_horizontal_list.dart';

import '../../../services/appointment_service.dart';
import '../../../services/patient_service.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedScheduleTab = 0;

  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<PatientSummary> _patients = [];
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadTabData();
  }

  // ======================================================
  // 🔹 LOAD DATA BASED ON TAB
  // ======================================================
  Future<void> _loadTabData() async {
    try {
      if (_selectedScheduleTab == 0) {
        await _fetchAppointmentsForDate(_selectedDate);
      } else if (_selectedScheduleTab == 1) {
        final res =
        await AppointmentService.getDoctorAppointmentsByStatus("completed");
        if (res["success"] == true) {
          setState(() {
            _appointments =
                (res["appointments"] as List)
                    .map((a) => Appointment.fromMap(a))
                    .toList();
          });
        }
      } else {
        final res =
        await AppointmentService.getDoctorAppointmentsByStatus("cancelled");
        if (res["success"] == true) {
          setState(() {
            _appointments =
                (res["appointments"] as List)
                    .map((a) => Appointment.fromMap(a))
                    .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Load failed: $e");
    }
  }

  // ======================================================
  // UPCOMING (DATE BASED)
  // ======================================================
  Future<void> _fetchAppointmentsForDate(DateTime date) async {
    try {
      final formatted =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final res =
      await AppointmentService.getDoctorAppointmentsByDate(formatted);

      if (res["success"] == true) {
        final appointments =
        (res["appointments"] as List)
            .map((a) => Appointment.fromMap(a))
            .toList();

        setState(() {
          _appointments = appointments;
        });

        await _buildPatientsFromAppointments(appointments);
      }
    } catch (e) {
      debugPrint("❌ Fetch failed: $e");
    }
  }

  Future<void> _buildPatientsFromAppointments(
      List<Appointment> appointments) async {
    final Map<String, PatientSummary> uniquePatients = {};

    for (final appt in appointments) {
      if (uniquePatients.containsKey(appt.patientId)) continue;

      final res = await PatientService.getProfile(appt.patientId);
      if (res["success"] == true) {
        final data = res["data"];
        uniquePatients[appt.patientId] = PatientSummary(
          uid: appt.patientId,
          name: "${data['firstName']} ${data['lastName']}".trim(),
          isMale: (data['gender'] ?? '').toLowerCase() == 'male',
        );
      }
    }

    if (mounted) {
      setState(() {
        _patients = uniquePatients.values.toList();
      });
    }
  }

  Future<void> _openDayAppointments(DateTime date) async {
    final pureDate = DateTime(date.year, date.month, date.day);
    await _fetchAppointmentsForDate(pureDate);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDayAppointmentsScreen(
          date: pureDate,
          allAppointments: _appointments,
          onAppointmentsUpdated: (_) => _loadTabData(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = Colors.grey.shade700;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            DoctorCalendarCard(
              focusedMonth: _focusedMonth,
              selectedDate: _selectedDate,
              onMonthChanged: (m) => setState(() => _focusedMonth = m),
              onDateSelected: (d) {
                setState(() {
                  _selectedDate = d;
                  _selectedScheduleTab = 0;
                });
                _openDayAppointments(d);
              },
            ),

            const SizedBox(height: 24),
            _buildScheduleTabs(),
            const SizedBox(height: 16),

            Column(
              children: _appointments
                  .map((appt) => AppointmentCard(
                appointment: appt,
                labelColor: labelColor,
                onActionCompleted: _loadTabData,
              ))
                  .toList(),
            ),

            const SizedBox(height: 24),
            const Text('Patients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            DoctorPatientHorizontalList(patients: _patients),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTabs() {
    final tabs = ['Upcoming', 'Completed', 'Cancelled'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedScheduleTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedScheduleTab = i);
                _loadTabData();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
