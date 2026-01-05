import 'package:flutter/material.dart';
import '../../doctor_patient_detail_screen.dart';
import '../models.dart';

class DoctorPatientHorizontalList extends StatelessWidget {
  final List<PatientSummary> patients;

  const DoctorPatientHorizontalList({
    super.key,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: patients.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final patient = patients[index];
          return _buildPatientCard(context, patient);
        },
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, PatientSummary patient) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorPatientDetailScreen(
                patientUid: patient.uid, // ✅ REAL UID
                patientName: patient.name,
              ),
            ),
          );
        },
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: patient.isMale
                      ? Colors.blue.withOpacity(0.15)
                      : Colors.pink.withOpacity(0.15),
                  child: Icon(
                    Icons.person,
                    color: patient.isMale ? Colors.blue : Colors.pink,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  patient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
