import 'package:flutter/material.dart';

class AuthScreenLogin extends StatefulWidget {
  const AuthScreenLogin({super.key});

  @override
  State<AuthScreenLogin> createState() => _AuthScreenLoginState();
}

class _AuthScreenLoginState extends State<AuthScreenLogin> {
  String _loginRole = 'Doctor';
  bool _patientOtpVisible = false;

  // Login controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginOtpController = TextEditingController();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _loginPhoneController.dispose();
    _loginOtpController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_loginRole == 'Doctor') {
      // Later add Firebase; for now just navigate
      Navigator.pushReplacementNamed(context, '/doctor-dashboard');
    } else {
      // Patient login: two-step (Generate OTP -> Login)
      if (!_patientOtpVisible) {
        setState(() {
          _patientOtpVisible = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mock: OTP generated for demo')),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/patient-dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String buttonText;
    if (_loginRole == 'Doctor') {
      buttonText = 'Login';
    } else {
      buttonText = _patientOtpVisible ? 'Login' : 'Generate OTP';
    }

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
            DropdownMenuItem(
              value: 'Doctor',
              child: Text('Doctor'),
            ),
            DropdownMenuItem(
              value: 'Patient',
              child: Text('Patient'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _loginRole = value;
              _patientOtpVisible = false;
            });
          },
        ),
        const SizedBox(height: 16),

        if (_loginRole == 'Doctor') ...[
          TextField(
            controller: _loginEmailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _loginPasswordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ] else ...[
          TextField(
            controller: _loginPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          if (_patientOtpVisible) ...[
            TextField(
              controller: _loginOtpController,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ],

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleLogin,
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
