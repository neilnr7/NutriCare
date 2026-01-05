import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../services/appointment_service.dart';

class ReportStep4BloodReports extends StatelessWidget {
  final String patientName;
  final String appointmentId;

  const ReportStep4BloodReports({
    super.key,
    required this.patientName,
    required this.appointmentId,
  });

  // TEMP static report data (replace with collected form values later)
  Map<String, dynamic> _buildReportPayload() {
    return {
      "patientName": patientName,
      "bloodReports": {
        "Hb": [],
        "FBS_PPBS": [],
        "HbA1c": [],
        "T3_T4_TSH": [],
        "VitaminD": [],
        "VitaminB12": [],
        "Cholesterol": [],
      },
      "generatedAt": DateTime.now().toIso8601String(),
    };
  }

  Future<void> _submitReport(BuildContext context) async {
    try {
      final reportPayload = _buildReportPayload();

      await AppointmentService.addAppointmentReport(
        appointmentId: appointmentId,
        report: jsonEncode(reportPayload),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Report submitted successfully")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to submit report: $e")),
      );
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _submitReport(context),
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
