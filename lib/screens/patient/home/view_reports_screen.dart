import 'package:flutter/material.dart';

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: const Center(
        child: Text(
          'Doctor generated report will appear here',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
