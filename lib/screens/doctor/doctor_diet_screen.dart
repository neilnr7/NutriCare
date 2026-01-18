import 'package:flutter/material.dart';
import '../../widgets/diet/diet_week_table.dart';
import '../../services/diet_service.dart';

class DoctorDietScreen extends StatefulWidget {
  const DoctorDietScreen({super.key});

  @override
  State<DoctorDietScreen> createState() => _DoctorDietScreenState();
}

class _DoctorDietScreenState extends State<DoctorDietScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final data = await DietService.getDoctorDietPatients();
      setState(() {
        _patients = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load patients")),
      );
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
          "Patients",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? const Center(child: Text("No patients found"))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _patients.length,
        separatorBuilder: (_, __) =>
            Divider(color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final patient = _patients[index];

          return ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child:
              const Icon(Icons.person, color: Colors.green),
            ),
            title: Text(
              patient["patientName"],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing:
            const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _DoctorAssignDietScreen(
                    patientId: patient["patientId"],
                    patientName: patient["patientName"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// =======================================================
// 🔹 DIET ASSIGNMENT SCREEN (Doctor → Patient)
// =======================================================
class _DoctorAssignDietScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const _DoctorAssignDietScreen({
    required this.patientId,
    required this.patientName,
  });

  @override
  State<_DoctorAssignDietScreen> createState() =>
      _DoctorAssignDietScreenState();
}

class _DoctorAssignDietScreenState extends State<_DoctorAssignDietScreen> {
  final GlobalKey<DietWeekTableState> _tableKey = GlobalKey();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDiet();
  }

  Future<void> _loadDiet() async {
    try {
      final response = await DietService.getDietForDoctor(
        patientId: widget.patientId,
      );

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
        const SnackBar(content: Text("Failed to load diet")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }



  bool _saving = false;

  Future<void> _saveDiet() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final weeklyDiet = _tableKey.currentState!.getWeeklyDiet();
      await DietService.saveDietPlan(
        patientId: widget.patientId,
        weeklyDiet: weeklyDiet,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diet plan saved")),
      );
    } finally {
      setState(() => _saving = false);
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
        title: Text(
          widget.patientName,
          style: const TextStyle(
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
        editable: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveDiet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save Diet Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
