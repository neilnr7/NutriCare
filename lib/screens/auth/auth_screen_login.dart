import 'package:flutter/material.dart';
import '../../services/doctor_service.dart';
import '../../services/patient_service.dart';
import '../../state/session.dart';

class AuthScreenLogin extends StatefulWidget {
  const AuthScreenLogin({super.key});

  @override
  State<AuthScreenLogin> createState() => _AuthScreenLoginState();
}

class _AuthScreenLoginState extends State<AuthScreenLogin> {
  String _loginRole = 'Doctor';

  // Doctor login controllers
  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Patient login controllers
  final TextEditingController _patientPhoneController = TextEditingController();
  final TextEditingController _patientPasswordController = TextEditingController();

  bool _patientPasswordObscured = true;
  bool _doctorPasswordObscured = true;

  @override
  void dispose() {
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();
    _patientPhoneController.dispose();
    _patientPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    try {
      Map<String, dynamic> response;

      if (_loginRole == 'Doctor') {
        // ❗ FIXED: Pass positional arguments, not named
        response = await DoctorService.loginDoctor(
          _loginPhoneController.text.trim(),
          _loginPasswordController.text.trim(),
        );

        if (response["success"] == true) {
          Session.uid = response["uid"];
          Navigator.pushReplacementNamed(context, '/doctor-dashboard');
          return;
        }

      } else {
        // ❗ FIXED: Positional arguments for patient login
        response = await PatientService.loginPatient(
          _patientPhoneController.text.trim(),
          _patientPasswordController.text.trim(),
        );

        if (response["success"] == true) {
          Navigator.pushReplacementNamed(context, '/patient-dashboard');
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["error"] ?? "Login failed")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String buttonText = 'Login';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _loginRole,
          decoration: const InputDecoration(
            labelText: 'Login as',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
            DropdownMenuItem(value: 'Patient', child: Text('Patient')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _loginRole = value);
          },
        ),
        const SizedBox(height: 16),

        // ================== DOCTOR LOGIN ==================
        if (_loginRole == 'Doctor') ...[
          TextField(
            controller: _loginPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _loginPasswordController,
            obscureText: _doctorPasswordObscured,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _doctorPasswordObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _doctorPasswordObscured = !_doctorPasswordObscured;
                  });
                },
              ),
            ),
          ),
        ]

        // ================== PATIENT LOGIN ==================
        else ...[
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
            controller: _patientPasswordController,
            obscureText: _patientPasswordObscured,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _patientPasswordObscured ? Icons.visibility_off : Icons.visibility,
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
            onPressed: _handleLogin,
            child: const Text(buttonText),
          ),
        ),
      ],
    );
  }
}
