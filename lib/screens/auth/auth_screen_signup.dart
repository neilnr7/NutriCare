import 'package:flutter/material.dart';
import '../../services/doctor_service.dart';
import '../../services/patient_service.dart';

class AuthScreenSignup extends StatefulWidget {
  final VoidCallback onSignupSuccess;

  const AuthScreenSignup({
    super.key,
    required this.onSignupSuccess,
  });

  @override
  State<AuthScreenSignup> createState() => _AuthScreenSignupState();
}

class _AuthScreenSignupState extends State<AuthScreenSignup> {
  String _signupRole = 'Doctor';
  bool _isLoading = false;

  // ---------- DOCTOR SIGNUP CONTROLLERS ----------
  final TextEditingController _doctorFirstNameController = TextEditingController();
  final TextEditingController _doctorMiddleNameController = TextEditingController();
  final TextEditingController _doctorLastNameController = TextEditingController();
  final TextEditingController _doctorPhoneController = TextEditingController();
  final TextEditingController _doctorEmailController = TextEditingController();
  final TextEditingController _doctorPasswordController = TextEditingController();
  final TextEditingController _doctorSpecializationController = TextEditingController();

  String _doctorGender = 'Male';
  bool _doctorPasswordObscured = true;

  // ---------- PATIENT SIGNUP CONTROLLERS ----------
  final TextEditingController _patientFirstNameController = TextEditingController();
  final TextEditingController _patientMiddleNameController = TextEditingController();
  final TextEditingController _patientLastNameController = TextEditingController();
  final TextEditingController _patientPhoneController = TextEditingController();
  final TextEditingController _patientEmailController = TextEditingController();
  final TextEditingController _patientPasswordController = TextEditingController();

  String _patientGender = 'Male';
  bool _patientPasswordObscured = true;

  @override
  void dispose() {
    _doctorFirstNameController.dispose();
    _doctorMiddleNameController.dispose();
    _doctorLastNameController.dispose();
    _doctorPhoneController.dispose();
    _doctorEmailController.dispose();
    _doctorPasswordController.dispose();
    _doctorSpecializationController.dispose();

    _patientFirstNameController.dispose();
    _patientMiddleNameController.dispose();
    _patientLastNameController.dispose();
    _patientPhoneController.dispose();
    _patientEmailController.dispose();
    _patientPasswordController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------------
  // 🔥 NEW SIGNUP FUNCTION
  // ------------------------------------------------------------------
  Future<void> _handleSignup() async {
    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> response;

      if (_signupRole == "Doctor") {
        response = await DoctorService.registerDoctor(
          firstName: _doctorFirstNameController.text.trim(),
          middleName: _doctorMiddleNameController.text.trim(),
          lastName: _doctorLastNameController.text.trim(),
          phone: _doctorPhoneController.text.trim(),
          email: _doctorEmailController.text.trim(),
          gender: _doctorGender.toLowerCase(),
          password: _doctorPasswordController.text.trim(),
          specialisation: _doctorSpecializationController.text.trim(),
        );
      } else {
        response = await PatientService.registerPatient(
          firstName: _patientFirstNameController.text.trim(),
          middleName: _patientMiddleNameController.text.trim(),
          lastName: _patientLastNameController.text.trim(),
          phone: _patientPhoneController.text.trim(),
          email: _patientEmailController.text.trim(),
          gender: _patientGender.toLowerCase(),
          password: _patientPasswordController.text.trim(),
        );
      }

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Please log in.")),
        );
        widget.onSignupSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["error"] ?? "Signup failed.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testBackend() async {
    final res = await DoctorService.sendOtp("neilrego3@gmail.com");
    print("TEST RESULT: $res");

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Backend Test: $res")));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create your account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _signupRole,
            decoration: const InputDecoration(
              labelText: 'Sign up as',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
              DropdownMenuItem(value: 'Patient', child: Text('Patient')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _signupRole = value);
            },
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------------
          // 🔥 DOCTOR SIGNUP UI (RESTORED)
          // ----------------------------------------------------------
          if (_signupRole == 'Doctor') ...[
            TextField(
              controller: _doctorFirstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorMiddleNameController,
              decoration: const InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorLastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _doctorGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _doctorGender = value);
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorPasswordController,
              obscureText: _doctorPasswordObscured,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _doctorPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _doctorPasswordObscured = !_doctorPasswordObscured;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _doctorSpecializationController,
              decoration: const InputDecoration(
                labelText: 'Specialization',
                border: OutlineInputBorder(),
              ),
            ),
          ],

          // ----------------------------------------------------------
          // 🔥 PATIENT SIGNUP UI (RESTORED)
          // ----------------------------------------------------------
          if (_signupRole == 'Patient') ...[
            TextField(
              controller: _patientFirstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _patientMiddleNameController,
              decoration: const InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _patientLastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _patientPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _patientEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _patientGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _patientGender = value);
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _patientPasswordController,
              obscureText: _patientPasswordObscured,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _patientPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _patientPasswordObscured = !_patientPasswordObscured;
                    });
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignup,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign Up'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _testBackend,
              child: const Text("TEST BACKEND"),
            ),
          ),
        ],
      ),
    );
  }
}
