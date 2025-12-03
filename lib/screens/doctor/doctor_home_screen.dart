import 'package:flutter/material.dart';
import 'doctor_patient_detail_screen.dart';
import 'doctor_patient_report_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // 0 = Upcoming, 1 = Completed, 2 = Cancelled
  int _selectedScheduleTab = 0;

  final List<_PatientSummary> _patients = const [
    _PatientSummary(name: 'Ram', isMale: true),
    _PatientSummary(name: 'Neil', isMale: true),
    _PatientSummary(name: 'Aditi', isMale: false),
    _PatientSummary(name: 'Arjun', isMale: true),
    _PatientSummary(name: 'Sara', isMale: false),
  ];

  final List<_Appointment> _appointments = const [
    _Appointment(
      patientName: 'Ram',
      date: '12/03/2025',
      time: '10:30 AM',
      status: AppointmentStatus.upcoming,
      isMale: true,
    ),
    _Appointment(
      patientName: 'Neil',
      date: '12/03/2025',
      time: '11:00 AM',
      status: AppointmentStatus.upcoming,
      isMale: true,
    ),
    _Appointment(
      patientName: 'Aditi',
      date: '12/03/2025',
      time: '11:30 AM',
      status: AppointmentStatus.completed,
      isMale: false,
    ),
    _Appointment(
      patientName: 'Arjun',
      date: '11/03/2025',
      time: '04:00 PM',
      status: AppointmentStatus.cancelled,
      isMale: true,
    ),
    _Appointment(
      patientName: 'Sara',
      date: '13/03/2025',
      time: '09:00 AM',
      status: AppointmentStatus.upcoming,
      isMale: false,
    ),
  ];

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
            // ---------- HOME / PATIENT LIST ----------
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 135,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _patients.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final patient = _patients[index];
                  return _buildPatientCard(patient);
                },
              ),
            ),
            const SizedBox(height: 24),

            // ---------- SCHEDULE TITLE ----------
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // ---------- TOGGLE: UPCOMING / COMPLETED / CANCELLED ----------
            _buildScheduleTabs(),
            const SizedBox(height: 16),

            // ---------- APPOINTMENT CARDS ----------
            Column(
              children: [
                for (final appt in filteredAppointments)
                  _AppointmentCard(
                    appointment: appt,
                    labelColor: labelColor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // horizontal patient chips
  Widget _buildPatientCard(_PatientSummary patient) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DoctorPatientDetailScreen(patientName: patient.name),
            ),
          );
        },
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: patient.isMale
                      ? Colors.blue.withOpacity(0.15)
                      : Colors.pink.withOpacity(0.15),
                  child: Icon(
                    Icons.person,
                    color: patient.isMale ? Colors.blue : Colors.pink,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  patient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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

// ---------------- MODELS ----------------

class _PatientSummary {
  final String name;
  final bool isMale;

  const _PatientSummary({
    required this.name,
    required this.isMale,
  });
}

enum AppointmentStatus { upcoming, completed, cancelled }

class _Appointment {
  final String patientName;
  final String date;
  final String time;
  final AppointmentStatus status;
  final bool isMale;

  const _Appointment({
    required this.patientName,
    required this.date,
    required this.time,
    required this.status,
    required this.isMale,
  });
}

// ---------------- APPOINTMENT CARD WIDGET ----------------

class _AppointmentCard extends StatelessWidget {
  final _Appointment appointment;
  final Color labelColor;

  const _AppointmentCard({
    required this.appointment,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        elevation: 2,
        child: InkWell(
          // whole card click animation
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // later: open detailed appointment
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name + avatar row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: appointment.isMale
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.pink.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: appointment.isMale
                            ? Colors.blue
                            : Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // date + time row
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      appointment.date,
                      style: TextStyle(
                        fontSize: 13,
                        color: valueColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      appointment.time,
                      style: TextStyle(
                        fontSize: 13,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // buttons section: depends on status
                if (appointment.status == AppointmentStatus.upcoming) ...[
                  // Upcoming: Cancel + Reschedule
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Cancel',
                          backgroundColor: Colors.grey.shade200,
                          textColor: Colors.grey.shade800,
                          onTap: () {
                            // later: handle cancel
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          label: 'Reschedule',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onTap: () {
                            // later: handle reschedule
                          },
                        ),
                      ),
                    ],
                  ),
                ] else if (appointment.status ==
                    AppointmentStatus.cancelled) ...[
                  // Cancelled: only Reschedule
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Reschedule',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onTap: () {
                            // later: handle reschedule
                          },
                        ),
                      ),
                    ],
                  ),
                ] else if (appointment.status ==
                    AppointmentStatus.completed) ...[
                  // Completed: Generate Report -> navigate
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Generate Report',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DoctorPatientReportScreen(
                                  patientName: appointment.patientName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// button with tap animation
class _ActionButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Material(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
