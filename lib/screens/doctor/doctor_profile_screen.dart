import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../state/session.dart';
import '../../services/api_service.dart';
import '../../services/doctor_service.dart';


class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();


}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  // These would normally come from registration / backend

  bool _loadingProfile = true;


  String firstName = '';
  String middleName = '';
  String lastName = '';
  String gender = '';
  String phoneNumber = '';
  String email = '';
  String specialization = '';


  // Extra profile details (setup profile)
  String? dob; // dd/mm/yyyy
  String? age;
  String? address;
  bool _profileCompleted = false;

  // Controllers for setup profile form
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specializationController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDoctorProfile();
  }


  @override
  void dispose() {
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctorProfile() async {
    if (Session.uid == null) return;

    try {
      final res = await DoctorService.getProfile(Session.uid!);

      if (res["success"] == true) {
        final d = res["data"];

        setState(() {
          firstName = d["firstName"] ?? '';
          middleName = d["middleName"] ?? '';
          lastName = d["lastName"] ?? '';
          gender = d["gender"] ?? '';
          phoneNumber = d["phone"] ?? '';
          email = d["email"] ?? '';
          specialization = d["specialisation"] ?? '';

          dob = d["dob"];
          age = d["age"]?.toString();
          address = d["address"];
          _profileCompleted = d["profileCompleted"] == true;

          _loadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }



  void _logout(BuildContext context) {
    // later: clear Firebase auth here
    Session.uid = null;
    Navigator.pushReplacementNamed(context, '/');
  }

  void _openSetupProfileSheet() {
    _dobController.text = dob ?? '';
    _ageController.text = age ?? '';
    _addressController.text = address ?? '';
    _specializationController.text = specialization;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final Color cardColor = Colors.white;
        final Color labelColor = Colors.grey.shade600;

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

                // DOB card
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date of Birth (dd/mm/yyyy)',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _dobController,
                          decoration: const InputDecoration(
                            hintText: '13/12/1998',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                            _DobTextInputFormatter(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Age + Address + Specialization card
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age',
                            style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _ageController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Text('Address',
                            style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        Text('Specialization',
                            style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _specializationController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final dobRaw = _dobController.text.replaceAll('/', '');
                      final formattedDob =
                          '${dobRaw.substring(0, 2)}/${dobRaw.substring(2, 4)}/${dobRaw.substring(4)}';

                      await DoctorService.updateProfile(
                        uid: Session.uid!,
                        dob: formattedDob,
                        age: int.parse(_ageController.text.trim()),
                        address: _addressController.text.trim(),
                        profilePicture: null,
                      );

                      await _loadDoctorProfile();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Profile Details'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final Color cardColor = Colors.white;
    final Color labelColor = Colors.grey.shade600;
    final Color valueColor = Colors.black87;

    final fullName = 'Dr. $firstName '
        '${middleName.isNotEmpty ? "$middleName " : ""}'
        '$lastName';

    String genderLabel =
    gender.isNotEmpty ? gender[0].toUpperCase() : '-';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD 1: Name + Age/Gender + Avatar
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side: name, age, gender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _profileCompleted && age != null
                                ? 'Age $age • Gender: $genderLabel'
                                : 'Gender: $genderLabel',
                            style: TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side: avatar
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.green.withOpacity(0.15),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),



            // CARD 3: Phone + Email
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // CARD 4: Extra profile details (Specialization, DOB, Age, Address) after setup
            if (_profileCompleted) ...[
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ---- Specialization (newly added here) ----
                      if (specialization.isNotEmpty) ...[
                        Text(
                          'Specialization',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: TextStyle(
                            fontSize: 16,
                            color: valueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ---- DOB ----
                      if (dob != null) ...[
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dob!,
                          style: TextStyle(
                            fontSize: 16,
                            color: valueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ---- Age ----
                      if (age != null) ...[
                        Text(
                          'Age',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          age!,
                          style: TextStyle(
                            fontSize: 16,
                            color: valueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ---- Address ----
                      if (address != null) ...[
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address!,
                          style: TextStyle(
                            fontSize: 16,
                            color: valueColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],


            // Setup profile button
            ElevatedButton(
              onPressed: _loadingProfile ? null : _openSetupProfileSheet,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _loadingProfile
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                _profileCompleted ? 'Update Profile Setup' : 'Setup Profile',
              ),
            ),

            const SizedBox(height: 12),

            // Logout button only
            OutlinedButton(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
}

/// Formats raw 8 digits into dd/mm/yyyy as you type
class _DobTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll('/', '');

    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    var buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
