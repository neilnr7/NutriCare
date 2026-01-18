import 'package:flutter/material.dart';
import '../../widgets/diet/diet_week_table.dart';
import '../../services/diet_service.dart';

class PatientDietScreen extends StatefulWidget {
  const PatientDietScreen({super.key});

  @override
  State<PatientDietScreen> createState() => _PatientDietScreenState();
}

class _PatientDietScreenState extends State<PatientDietScreen> {
  final GlobalKey<DietWeekTableState> _tableKey = GlobalKey();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDiet();
  }
  Future<void> _loadDiet() async {
    try {
      final response = await DietService.getDietForPatient();

      if (response != null && response["diet"] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tableKey.currentState?.setWeeklyDiet(response["diet"]);
          _tableKey.currentState?.setCompletionStatus(
            response["status"] ?? {},
          );
        });
      } else {
        // ✅ Diet not assigned yet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diet not assigned yet")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load diet plan")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF5F6F8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Diet Plan",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : DietWeekTable(
        key: _tableKey,
        editable: false, // 👤 patient read-only
      ),
    );
  }
}
