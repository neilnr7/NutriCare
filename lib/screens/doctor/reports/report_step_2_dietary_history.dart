import 'package:flutter/material.dart';
import 'report_step_3_body_measurements.dart';

class ReportStep2DietaryHistory extends StatelessWidget {
  final String patientName;
  final String appointmentId;

  const ReportStep2DietaryHistory({super.key, required this.patientName, required this.appointmentId});

  DataRow _row() => const DataRow(cells: [
    DataCell(_Cell()),
    DataCell(_Cell()),
    DataCell(_Cell()),
    DataCell(_Cell()),
    DataCell(_Cell()),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dietary History")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text("Time")),
                      DataColumn(label: Text("Food")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Preparation")),
                      DataColumn(label: Text("Home / Outside")),
                    ],
                    rows: List.generate(6, (_) => _row()),
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
                  ReportStep3BodyMeasurements(
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
      width: 120,
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
