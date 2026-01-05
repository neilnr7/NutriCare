import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';
import '../../../services/patient_service.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final String patientUid;
  final String patientName;

  const DoctorPatientDetailScreen({
    super.key,
    required this.patientUid,
    required this.patientName,
  });

  @override
  State<DoctorPatientDetailScreen> createState() =>
      _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen> {
  PatientProfile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientProfile();
  }

  // ======================================================
  // LOAD PATIENT PROFILE (BACKEND)
  // ======================================================
  Future<void> _loadPatientProfile() async {
    try {
      final res = await PatientService.getProfile(widget.patientUid);

      if (res["success"] == true && res["data"] != null) {
        final data = res["data"];

        setState(() {
          profile = PatientProfile(
            firstName: data["firstName"] ?? "",
            middleName: data["middleName"] ?? "",
            lastName: data["lastName"] ?? "",
            phone: data["phone"] ?? "",
            email: data["email"] ?? "",
            dob: data["dob"] ?? "",
            age: data["age"]?.toString() ?? "",
            address: data["address"] ?? "",
          );
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Failed to load patient profile: $e");
      setState(() => isLoading = false);
    }
  }

  Widget infoCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? const Center(child: Text("Patient profile not found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            infoCard(
              "Full Name",
              "${profile!.firstName} "
                  "${profile!.middleName.isNotEmpty ? profile!.middleName + " " : ""}"
                  "${profile!.lastName}",
            ),
            infoCard("Phone Number", profile!.phone),
            infoCard("Email", profile!.email),
            infoCard("Date of Birth", profile!.dob),
            infoCard("Age", profile!.age),
            infoCard("Address", profile!.address),
          ],
        ),
      ),
    );
  }
}
