import 'package:flutter/material.dart';
import 'reports/report_step_1_basic_details.dart';

class DoctorPatientReportScreen extends StatelessWidget {
  final String patientName;

  const DoctorPatientReportScreen({
    super.key,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report - $patientName')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ReportStep1BasicDetails(patientName: patientName),
              ),
            );
          },
          child: const Text("Generate Report"),
        ),
      ),
    );
  }
}
