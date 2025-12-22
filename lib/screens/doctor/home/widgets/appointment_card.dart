import 'package:flutter/material.dart';
import '../../doctor_patient_report_screen.dart';
import '../models.dart';
import 'action_button.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Color labelColor;

  const AppointmentCard({
    super.key,
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
                      formatDate(appointment.date),
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
                        child: ActionButton(
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
                        child: ActionButton(
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
                ] else if (appointment.status == AppointmentStatus.cancelled) ...[
                  // Cancelled: only Reschedule
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
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
                ] else if (appointment.status == AppointmentStatus.completed) ...[
                  // Completed: Generate Report -> navigate
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
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
