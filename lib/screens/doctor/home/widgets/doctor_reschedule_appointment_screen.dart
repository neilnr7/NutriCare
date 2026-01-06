import 'package:flutter/material.dart';
import '../models.dart';
import '../../../../services/appointment_service.dart';

class DoctorRescheduleAppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  final VoidCallback? onRescheduled;

  const DoctorRescheduleAppointmentScreen({
    super.key,
    required this.appointment,
    this.onRescheduled,
  });

  @override
  State<DoctorRescheduleAppointmentScreen> createState() =>
      _DoctorRescheduleAppointmentScreenState();
}

class _DoctorRescheduleAppointmentScreenState
    extends State<DoctorRescheduleAppointmentScreen> {
  DateTime? _selectedDate;
  String _startTime = "10:00";
  String _endTime = "10:30";
  bool _loading = false;

  // --------------------------------------------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.appointment.appointmentDate.add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // --------------------------------------------------
  Future<void> _submit() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final date =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      await AppointmentService.rescheduleAppointment(
        appointmentId: widget.appointment.appointmentId,
        newDate: date,
        newStartTime: _startTime,
        newEndTime: _endTime,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment rescheduled")),
      );

      widget.onRescheduled?.call();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) setState(() => _loading = false);
  }

  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reschedule Appointment"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // DATE
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? "Select New Date"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
              ),
              const SizedBox(height: 16),

              // TIME
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Start Time (HH:mm)",
                        border: OutlineInputBorder(),
                      ),
                      controller:
                      TextEditingController(text: _startTime),
                      onChanged: (v) => _startTime = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "End Time (HH:mm)",
                        border: OutlineInputBorder(),
                      ),
                      controller:
                      TextEditingController(text: _endTime),
                      onChanged: (v) => _endTime = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SUBMIT
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Reschedule"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
