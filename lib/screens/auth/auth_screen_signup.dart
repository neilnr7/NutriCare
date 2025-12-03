import 'package:flutter/material.dart';

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

  // Signup controllers
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
  TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();

  @override
  void dispose() {
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupPhoneController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    // Later: call Firebase here.
    // For now, just show a message and switch to Login tab.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed up! Please log in.')),
    );

    widget.onSignupSuccess(); // this flips tab to Login in AuthScreen
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              _signupRole = value;
            });
          },
        ),
        const SizedBox(height: 16),

        if (_signupRole == 'Doctor') ...[
          TextField(
            controller: _signupNameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _signupEmailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _signupPasswordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ] else ...[
          // Patient signup: name + phone (your requested change)
          TextField(
            controller: _signupNameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _signupPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleSignup,
            child: const Text('Sign Up'),
          ),
        ),
      ],
    );
  }
}
