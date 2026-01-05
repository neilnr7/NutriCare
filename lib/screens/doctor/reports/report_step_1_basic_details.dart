import 'package:flutter/material.dart';
import 'report_step_2_dietary_history.dart';

class ReportStep1BasicDetails extends StatelessWidget {
  final String patientName;
  final String appointmentId;
  const ReportStep1BasicDetails({super.key, required this.patientName, required this.appointmentId});

  Widget field(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              field("Age"),
              field("Gender"),
              field("DOB"),
              field("Height (cm)"),
              field("Weight (kg)"),
              field("Address"),
              field("Occupation"),
              field("Food Preference"),
              field("Physical Activity"),
              field("Chief Complaints"),
              field("Family History"),
              field("Sleep Cycle"),
              field("Stress (1–10)"),
              field("Goals"),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ReportStep2DietaryHistory(
                              appointmentId: appointmentId,
                              patientName: patientName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
