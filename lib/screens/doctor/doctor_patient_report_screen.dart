import 'package:flutter/material.dart';
import 'reports/report_step_1_basic_details.dart';

class DoctorPatientReportScreen extends StatelessWidget {
  final String appointmentId; // ✅ REQUIRED FOR BACKEND
  final String patientName;

  const DoctorPatientReportScreen({
    super.key,
    required this.appointmentId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report - $patientName'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportStep1BasicDetails(
                  appointmentId: appointmentId, // ✅ PASS FOR BACKEND
                  patientName: patientName,
                ),
              ),
            );
          },
          child: const Text("Generate Report"),
        ),
      ),
    );
  }
}
