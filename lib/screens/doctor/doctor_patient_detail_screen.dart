import 'package:flutter/material.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  final String patientName;

  const DoctorPatientDetailScreen({
    super.key,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientName),
      ),
      body: const Center(
        child: Text(
          'Patient profile & details (dummy for now)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
