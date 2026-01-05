import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/appointment_card.dart';
import '../../../services/appointment_service.dart';

class DoctorDayAppointmentsScreen extends StatefulWidget {
  final DateTime date;
  final List<Appointment> allAppointments;
  final ValueChanged<List<Appointment>> onAppointmentsUpdated;

  const DoctorDayAppointmentsScreen({
    super.key,
    required this.date,
    required this.allAppointments,
    required this.onAppointmentsUpdated,
  });

  @override
  State<DoctorDayAppointmentsScreen> createState() =>
      _DoctorDayAppointmentsScreenState();
}

class _DoctorDayAppointmentsScreenState
    extends State<DoctorDayAppointmentsScreen> {
  late DateTime _currentDate;
  late List<Appointment> _dayAppointments;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentDate =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    _filterAppointments();
  }

  void _filterAppointments() {
    _dayAppointments = widget.allAppointments
        .where((a) => isSameDay(a.appointmentDate, _currentDate))
        .toList();
  }

  // ======================================================
  // BACKEND — GENERATE NEXT WEEK APPOINTMENTS
  // ======================================================
  Future<void> _generateNextAppointments() async {
    if (_dayAppointments.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      for (final appt in _dayAppointments) {
        if (appt.isRecurring && appt.recurrenceType == "weekly") {
          await AppointmentService.generateWeeklyAppointment(
            appointmentId: appt.appointmentId,
          );
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Next week appointments generated successfully'),
        ),
      );

      Navigator.pop(context); // DoctorHome will refetch
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final labelColor = Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments - ${formatDate(_currentDate)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _dayAppointments.isEmpty
                  ? const Center(
                child: Text('No appointments for this day'),
              )
                  : ListView.builder(
                itemCount: _dayAppointments.length,
                itemBuilder: (context, index) {
                  final appt = _dayAppointments[index];
                  return AppointmentCard(
                    appointment: appt,
                    labelColor: labelColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateNextAppointments,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Generate Next Appointments'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
