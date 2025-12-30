import 'package:flutter/material.dart';

class ReportStep4BloodReports extends StatelessWidget {
  final String patientName;

  const ReportStep4BloodReports({super.key, required this.patientName});

  DataRow _row(String test) => DataRow(cells: [
    DataCell(Text(test)),
    const DataCell(_Cell()),
    const DataCell(_Cell()),
    const DataCell(_Cell()),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blood Reports")),
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
                      DataColumn(label: Text("Test")),
                      DataColumn(label: Text("Date & Value")),
                      DataColumn(label: Text("Date & Value")),
                      DataColumn(label: Text("Date & Value")),
                    ],
                    rows: [
                      _row("Hb"),
                      _row("FBS & PPBS"),
                      _row("HbA1c"),
                      _row("T3 / T4 / TSH"),
                      _row("Vitamin D"),
                      _row("Vitamin B12"),
                      _row("Cholesterol"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Full Report Generated (UI only)"),
                    ),
                  );
                },
                child: const Text("Generate Full Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
