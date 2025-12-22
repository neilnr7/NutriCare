import 'package:flutter/material.dart';

import 'models.dart';
import 'doctor_calendar_card.dart';
import 'doctor_day_appointments_screen.dart';
import 'widgets/appointment_card.dart';
import 'widgets/doctor_patient_horizontal_list.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // 0 = Upcoming, 1 = Completed, 2 = Cancelled
  int _selectedScheduleTab = 0;

  // calendar state
  DateTime _focusedMonth = DateTime.now(); // first day of current month
  DateTime _selectedDate = DateTime.now();

  final List<PatientSummary> _patients = const [
    PatientSummary(name: 'Ram', isMale: true),
    PatientSummary(name: 'Neil', isMale: true),
    PatientSummary(name: 'Aditi', isMale: false),
    PatientSummary(name: 'Arjun', isMale: true),
    PatientSummary(name: 'Sara', isMale: false),
  ];

  List<Appointment> _appointments = [
    Appointment(
      patientName: 'Ram',
      date: DateTime(2025, 12, 3),
      time: '10:30 AM',
      status: AppointmentStatus.upcoming,
      isMale: true,
    ),
    Appointment(
      patientName: 'Neil',
      date: DateTime(2025, 12, 3),
      time: '11:00 AM',
      status: AppointmentStatus.upcoming,
      isMale: true,
    ),
    Appointment(
      patientName: 'Aditi',
      date: DateTime(2025, 12, 4),
      time: '11:30 AM',
      status: AppointmentStatus.completed,
      isMale: false,
    ),
    Appointment(
      patientName: 'Arjun',
      date: DateTime(2025, 12, 4),
      time: '04:00 PM',
      status: AppointmentStatus.cancelled,
      isMale: true,
    ),
    Appointment(
      patientName: 'Sara',
      date: DateTime(2025, 12, 13),
      time: '09:00 AM',
      status: AppointmentStatus.upcoming,
      isMale: false,
    ),
  ];

  void _openDayAppointments(DateTime date) {
    final pureDate = DateTime(date.year, date.month, date.day);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDayAppointmentsScreen(
          date: pureDate,
          allAppointments: _appointments,
          onAppointmentsUpdated: (updated) {
            setState(() {
              _appointments = updated;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = Colors.grey.shade700;

    // filter appointments based on selected tab
    final filteredAppointments = _appointments.where((a) {
      switch (_selectedScheduleTab) {
        case 0:
          return a.status == AppointmentStatus.upcoming;
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Calendar at top
            DoctorCalendarCard(
              focusedMonth: _focusedMonth,
              selectedDate: _selectedDate,
              onMonthChanged: (newMonth) {
                setState(() {
                  _focusedMonth = newMonth;
                });
              },
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
                _openDayAppointments(date);
              },
            ),
            const SizedBox(height: 24),

            // Schedule section
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Patients horizontal list at bottom
            const Text(
              'Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DoctorPatientHorizontalList(patients: _patients),
          ],
        ),
      ),
    );
  }

  // segmented control for schedule
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
                setState(() {
                  _selectedScheduleTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
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
