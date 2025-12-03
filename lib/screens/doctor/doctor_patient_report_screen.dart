import 'package:flutter/material.dart';

class DoctorPatientReportScreen extends StatelessWidget {
  final String patientName;

  const DoctorPatientReportScreen({
    super.key,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report - $patientName'),
      ),
      body: Center(
        child: Text(
          'Patient report for $patientName\n(placeholder screen)',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
