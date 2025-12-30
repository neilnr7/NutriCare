import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';

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
    _loadDummyProfile();
  }

  // ✅ FRONTEND-ONLY DUMMY DATA
  void _loadDummyProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    setState(() {
      profile = PatientProfile(
        firstName: "Aarav",
        middleName: "",
        lastName: "Sharma",
        phone: "+91 9876543210",
        email: "aarav.sharma@example.com",
        dob: "12/08/2001",
        age: "23",
        address: "Bengaluru, Karnataka",
      );
      isLoading = false;
    });
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
