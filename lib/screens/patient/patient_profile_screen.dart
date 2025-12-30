import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../state/session.dart';
import '../../services/patient_service.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _loadingProfile = true;

  // Basic profile
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String gender = '';
  String phoneNumber = '';
  String email = '';

  // Extra profile
  String? dob;
  String? age;
  String? address;
  bool _profileCompleted = false;

  // Controllers
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientProfile();
  }

  @override
  void dispose() {
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientProfile() async {
    if (Session.uid == null) return;

    try {
      final res = await PatientService.getProfile(Session.uid!);

      if (res["success"] == true) {
        final d = res["data"];

        setState(() {
          firstName = d["firstName"] ?? '';
          middleName = d["middleName"] ?? '';
          lastName = d["lastName"] ?? '';
          gender = d["gender"] ?? '';
          phoneNumber = d["phone"] ?? '';
          email = d["email"] ?? '';

          dob = d["dob"];
          age = d["age"]?.toString();
          address = d["address"];
          _profileCompleted = d["profileCompleted"] == true;

          _loadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint("Patient profile load error: $e");
    }
  }

  void _logout(BuildContext context) {
    Session.uid = null;
    Navigator.pushReplacementNamed(context, '/');
  }

  void _openSetupProfileSheet() {
    _dobController.text = dob ?? '';
    _ageController.text = age ?? '';
    _addressController.text = address ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: bottomInset + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Text(
                  'Setup Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                _inputCard(
                  label: 'Date of Birth (dd/mm/yyyy)',
                  controller: _dobController,
                  hint: '13/12/1998',
                  keyboard: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _DobTextInputFormatter(),
                  ],
                ),

                _inputCard(
                  label: 'Age',
                  controller: _ageController,
                  hint: '24',
                  keyboard: TextInputType.number,
                ),

                _inputCard(
                  label: 'Address',
                  controller: _addressController,
                  hint: 'Home address',
                  maxLines: 2,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    final dobRaw =
                    _dobController.text.replaceAll('/', '');

                    if (dobRaw.length != 8) return;

                    final formattedDob =
                        '${dobRaw.substring(0, 2)}/${dobRaw.substring(2, 4)}/${dobRaw.substring(4)}';

                    try {
                      await PatientService.updateProfile(
                        uid: Session.uid!,
                        dob: formattedDob,
                        age: int.parse(_ageController.text.trim()),
                        address: _addressController.text.trim(),
                      );

                      await _loadPatientProfile();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Profile update failed")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Save Profile Details'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputCard({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName =
        "$firstName ${middleName.isNotEmpty ? middleName + " " : ""}$lastName";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            infoCard("Full Name", fullName),
            infoCard("Phone Number", phoneNumber),
            infoCard("Email", email),

            if (_profileCompleted) ...[
              infoCard("Date of Birth", dob ?? "-"),
              infoCard("Age", age ?? "-"),
              infoCard("Address", address ?? "-"),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loadingProfile ? null : _openSetupProfileSheet,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _profileCompleted ? 'Update Profile' : 'Setup Profile',
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                side: BorderSide(color: Colors.red.shade300),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// DOB formatter dd/mm/yyyy
class _DobTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll('/', '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    var buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
