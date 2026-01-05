import 'package:flutter/material.dart';
import 'report_step_4_blood_reports.dart';

class ReportStep3BodyMeasurements extends StatelessWidget {
  final String patientName;
  final String appointmentId;

  const ReportStep3BodyMeasurements({super.key, required this.patientName, required this.appointmentId});

  DataRow _row(String label) => DataRow(cells: [
    DataCell(Text(label)),
    const DataCell(_Cell()),
    const DataCell(_Cell()),
    const DataCell(_Cell()),
    const DataCell(_Cell()),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Body Measurements")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text("Parameter")),
                      DataColumn(label: Text("Visit 1")),
                      DataColumn(label: Text("Visit 2")),
                      DataColumn(label: Text("Visit 3")),
                      DataColumn(label: Text("Visit 4")),
                    ],
                    rows: [
                      _row("Biceps"),
                      _row("Forearm"),
                      _row("Chest"),
                      _row("Waist"),
                      _row("Hip"),
                      _row("Thigh"),
                      _row("Calf"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "On Medications",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            _nextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ReportStep4BloodReports(
                      appointmentId: appointmentId,
                      patientName: patientName),
            ),
          );
        },
        child: const Text("Next"),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
