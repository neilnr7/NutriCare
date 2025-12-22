import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/appointment_card.dart';

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

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime(widget.date.year, widget.date.month, widget.date.day);
    _dayAppointments = widget.allAppointments
        .where((a) => isSameDay(a.date, _currentDate))
        .toList();
  }

  void _generateNextAppointments() {
    final nextDate = _currentDate.add(const Duration(days: 7));

    final newAppointments = _dayAppointments
        .map(
          (appt) => Appointment(
        patientName: appt.patientName,
        date: nextDate,
        time: appt.time,
        status: AppointmentStatus.upcoming,
        isMale: appt.isMale,
      ),
    )
        .toList();

    final updatedAll = [...widget.allAppointments, ...newAppointments];
    widget.onAppointmentsUpdated(updatedAll);

    setState(() {
      _currentDate = nextDate;
      _dayAppointments = newAppointments;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Next week appointments created for ${formatDate(nextDate)}',
        ),
      ),
    );
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
                onPressed: _generateNextAppointments,
                child: const Text('Generate Next Appointments'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
