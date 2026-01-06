import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/doctor_service.dart';
import '../../services/patient_service.dart';
import '../../state/session.dart';
import '../../services/api_auth_storage.dart';

class AuthScreenLogin extends StatefulWidget {
  const AuthScreenLogin({super.key});

  @override
  State<AuthScreenLogin> createState() => _AuthScreenLoginState();
}

class _AuthScreenLoginState extends State<AuthScreenLogin> {
  String _loginRole = 'Doctor';

  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _patientPhoneController = TextEditingController();
  final TextEditingController _patientPasswordController =
  TextEditingController();

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
        response = await DoctorService.loginDoctor(
          _loginPhoneController.text.trim(),
          _loginPasswordController.text.trim(),
        );
      } else {
        response = await PatientService.loginPatient(
          _patientPhoneController.text.trim(),
          _patientPasswordController.text.trim(),
        );
      }

      if (response["success"] == true) {
        final String? customToken = response["token"];
        final String? uid = response["uid"];

        if (customToken == null ||
            customToken.isEmpty ||
            uid == null ||
            uid.isEmpty) {
          throw Exception("Invalid auth data received from server");
        }

        Session.uid = uid;

        // 🔐 Firebase login
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

        // 🔑 Firebase ID token
        final idToken =
        await FirebaseAuth.instance.currentUser!.getIdToken(true);

        if (idToken == null || idToken.isEmpty) {
          throw Exception("Failed to retrieve Firebase ID token");
        }

        // ✅ EXISTING
        await Session.saveToken(idToken);

        // ✅ REQUIRED FOR CHAT (NEW, SAFE)
        await ApiAuthStorage.saveAuthData(
          uid: uid,
          token: idToken,
          role: _loginRole.toLowerCase(), // "doctor" or "patient"
        );

        Navigator.pushReplacementNamed(
          context,
          _loginRole == 'Doctor'
              ? '/doctor-dashboard'
              : '/patient-dashboard',
        );
        return;
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
            if (value != null) setState(() => _loginRole = value);
          },
        ),
        const SizedBox(height: 16),

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
        ] else ...[
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
            onPressed: _handleLogin,
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }
}
