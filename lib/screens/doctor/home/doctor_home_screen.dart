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
    _fetchAppointmentsForDate(_selectedDate);
  }

  Future<void> _fetchAppointmentsForDate(DateTime date) async {
    try {
      final formatted =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final res =
      await AppointmentService.getDoctorAppointmentsByDate(formatted);

      if (res["success"] == true) {
        final List list = res["appointments"];

        final appointments =
        list.map((a) => Appointment.fromMap(a)).toList();

        setState(() {
          _appointments = appointments;
        });
        await _buildPatientsFromAppointments(appointments);
      }
    } catch (e) {
      debugPrint("❌ Fetch appointments failed: $e");
    }
  }

  Future<void> _buildPatientsFromAppointments(
      List<Appointment> appointments) async {
    final Map<String, PatientSummary> uniquePatients = {};

    for (final appt in appointments) {
      if (uniquePatients.containsKey(appt.patientId)) continue;

      try {
        final res = await PatientService.getProfile(appt.patientId);

        if (res["success"] == true) {
          final data = res["data"];

          final fullName =
          "${data['firstName']} ${data['lastName']}".trim();

          final isMale =
              (data['gender'] ?? '').toLowerCase() == 'male';

          uniquePatients[appt.patientId] = PatientSummary(
            uid: appt.patientId,
            name: fullName,
            isMale: isMale,
          );
        }
      } catch (e) {
        debugPrint("⚠️ Failed loading patient ${appt.patientId}: $e");
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
          onAppointmentsUpdated: (updated) {
            setState(() => _appointments = updated);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = Colors.grey.shade700;

    final filteredAppointments = _appointments.where((a) {
      switch (_selectedScheduleTab) {
        case 0:
          return a.status == AppointmentStatus.requested ||
              a.status == AppointmentStatus.approved;
        case 1:
          return a.status == AppointmentStatus.completed;
        case 2:
          return a.status == AppointmentStatus.cancelled;
      }
      return true;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            DoctorCalendarCard(
              focusedMonth: _focusedMonth,
              selectedDate: _selectedDate,
              onMonthChanged: (newMonth) {
                setState(() => _focusedMonth = newMonth);
              },
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                _openDayAppointments(date);
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildScheduleTabs(),
            const SizedBox(height: 16),

            Column(
              children: [
                for (final appt in filteredAppointments)
                  AppointmentCard(
                    appointment: appt,
                    labelColor: labelColor,

                    // 🔹 ONLY ADDITION
                    onActionCompleted: () {
                      _fetchAppointmentsForDate(_selectedDate);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Patients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
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
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedScheduleTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedScheduleTab = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
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
