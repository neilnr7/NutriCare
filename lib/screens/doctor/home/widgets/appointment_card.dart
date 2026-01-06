import 'package:flutter/material.dart';
import '../../doctor_patient_report_screen.dart';
import '../models.dart';
import 'action_button.dart';
import '../../../../services/appointment_service.dart';

// 🔹 NEW import (doctor reschedule UI)
import './doctor_reschedule_appointment_screen.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Color labelColor;

  final VoidCallback? onActionCompleted;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.labelColor,
    this.onActionCompleted,
  });

  Future<void> _cancelAppointment(BuildContext context) async {
    try {
      await AppointmentService.updateAppointmentStatus(
        appointmentId: appointment.appointmentId,
        status: "cancelled",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment cancelled')),
      );

      onActionCompleted?.call();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // 🔹 NEW: COMPLETE APPOINTMENT
  Future<void> _completeAppointment(BuildContext context) async {
    try {
      await AppointmentService.updateAppointmentStatus(
        appointmentId: appointment.appointmentId,
        status: "completed",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment completed')),
      );

      onActionCompleted?.call();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // 🔹 UPDATED: OPEN RESCHEDULE SCREEN
  void _openReschedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorRescheduleAppointmentScreen(
          appointment: appointment,
          onRescheduled: onActionCompleted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final valueColor = Colors.black87;

    final patientName = appointment.patientName ?? 'Patient';
    final isMale = true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isMale
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.pink.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: isMale ? Colors.blue : Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      formatDate(appointment.appointmentDate),
                      style: TextStyle(fontSize: 13, color: valueColor),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "${appointment.startTime} - ${appointment.endTime}",
                      style: TextStyle(fontSize: 13, color: valueColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (appointment.status == AppointmentStatus.requested ||
                    appointment.status == AppointmentStatus.approved) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          label: 'Cancel',
                          backgroundColor: Colors.grey.shade200,
                          textColor: Colors.grey.shade800,
                          onTap: () => _cancelAppointment(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ActionButton(
                          label: 'Reschedule',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onTap: () => _openReschedule(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          label: 'Complete',
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          onTap: () => _completeAppointment(context),
                        ),
                      ),
                    ],
                  ),
                ] else if (appointment.status ==
                    AppointmentStatus.cancelled) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          label: 'Reschedule',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onTap: () => _openReschedule(context),
                        ),
                      ),
                    ],
                  ),
                ] else if (appointment.status ==
                    AppointmentStatus.completed) ...[
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
                                  appointmentId: appointment.appointmentId,
                                  patientName: patientName,
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
