import 'package:flutter/material.dart';
import '../../../services/appointment_service.dart';
import '../../../services/doctor_service.dart';
import '../../../services/chat_service.dart';
import '../../../services/api_auth_storage.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // ✅ DYNAMIC doctor list
  Map<String, String> _doctors = {};

  String? _selectedDoctorId;
  DateTime? _selectedDate;
  String _startTime = "10:00";
  String _endTime = "10:30";
  bool _isWeekly = false;

  final TextEditingController _reasonCtrl = TextEditingController();
  bool _loading = false;
  bool _loadingDoctors = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  // --------------------------------------------------
  Future<void> _fetchDoctors() async {
    try {
      final res = await DoctorService.getDoctors();

      if (res["success"] == true) {
        final Map<String, String> map = {};
        for (final d in res["doctors"]) {
          map[d["uid"]] = d["name"];
        }

        if (mounted) {
          setState(() {
            _doctors = map;
            _loadingDoctors = false;
          });
        }
      }
    } catch (e) {
      setState(() => _loadingDoctors = false);
    }
  }

  // --------------------------------------------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // --------------------------------------------------
  Future<void> _submit() async {
    if (_selectedDoctorId == null ||
        _selectedDate == null ||
        _reasonCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final date =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      final res = await AppointmentService.createAppointment(
        doctorId: _selectedDoctorId!,
        appointmentDate: date,
        startTime: _startTime,
        endTime: _endTime,
        reason: _reasonCtrl.text.trim(),
        isRecurring: _isWeekly,
        recurrenceType: _isWeekly ? "weekly" : "none",
      );

      if (!mounted) return;

      if (res["success"] == true) {
        // ✅ OPTION 3 — AUTO CREATE CHAT (SILENT)
        final patientId = await ApiAuthStorage.getUid();
        if (patientId != null) {
          await ChatService.createOrGetChat(
            doctorId: _selectedDoctorId!,
            patientId: patientId,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment booked successfully")),
        );
        Navigator.pop(context);
      } else {
        throw res["error"] ?? "Booking failed";
      }
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
      appBar: AppBar(title: const Text("Book Appointment")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // DOCTOR
              _loadingDoctors
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                value: _selectedDoctorId,
                decoration: const InputDecoration(
                  labelText: "Select Doctor",
                  border: OutlineInputBorder(),
                ),
                items: _doctors.entries
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ),
                )
                    .toList(),
                onChanged: (v) =>
                    setState(() => _selectedDoctorId = v),
              ),
              const SizedBox(height: 16),

              // DATE
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? "Select Date"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
              ),
              const SizedBox(height: 16),

              // TIME SLOT
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
              const SizedBox(height: 16),

              // REASON
              TextField(
                controller: _reasonCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // WEEKLY
              SwitchListTile(
                value: _isWeekly,
                onChanged: (v) => setState(() => _isWeekly = v),
                title: const Text("Repeat Weekly"),
              ),
              const SizedBox(height: 24),

              // SUBMIT
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Book Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
