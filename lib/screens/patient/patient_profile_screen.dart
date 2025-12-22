import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  // These would normally come from registration / backend
  String firstName = 'John';
  String middleName = 'A.';
  String lastName = 'Doe';
  String gender = 'Male'; // or 'Female'
  String phoneNumber = '9876543210';
  String email = 'john.doe@example.com';

  // Extra profile details (setup profile)
  String? dob; // dd/mm/yyyy
  String? age;
  String? address;
  bool _profileCompleted = false;

  // Controllers for setup profile form
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    // later: clear Firebase auth here
    Navigator.pushReplacementNamed(context, '/');
  }

  void _openSetupProfileSheet() {
    // prefill if already set
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
        final Color cardColor = Colors.white;
        final Color labelColor = Colors.grey.shade600;
        final Color valueColor = Colors.black87;

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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Profile picture card placeholder
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 15,
                              color: valueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // later: open image picker
                          },
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Change'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // DOB card (with auto-slash formatter)
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
                            hintText: '13/12/2004',
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

                // Age + Address card
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
                          'Age',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            hintText: '21',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: 'Home address / City',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final dobRaw = _dobController.text.replaceAll('/', '');
                        if (dobRaw.trim().isEmpty) {
                          dob = null;
                        } else if (dobRaw.length == 8) {
                          // store with proper slashes
                          dob =
                          '${dobRaw.substring(0, 2)}/${dobRaw.substring(2, 4)}/${dobRaw.substring(4)}';
                        } else {
                          dob = _dobController.text.trim();
                        }

                        age = _ageController.text.trim().isEmpty
                            ? null
                            : _ageController.text.trim();
                        address = _addressController.text.trim().isEmpty
                            ? null
                            : _addressController.text.trim();

                        _profileCompleted =
                            dob != null || age != null || address != null;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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

    final fullName = '$firstName '
        '${middleName.isNotEmpty ? "$middleName " : ""}'
        '$lastName';

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
                                ? 'Age $age • Gender: ${gender[0].toUpperCase()}'
                                : 'Gender: ${gender[0].toUpperCase()}',
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

            // CARD 2: Phone + Email
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

            // CARD 3: Extra profile details (DOB, Age, Address) after setup
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
              onPressed: _openSetupProfileSheet,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
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
