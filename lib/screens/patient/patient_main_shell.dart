import 'package:flutter/material.dart';
import '../../widgets/main_bottom_nav_bar.dart';

// UPDATED IMPORT PATH
import 'home/patient_home_screen.dart';

import 'patient_chat_screen.dart';
import 'patient_diet_screen.dart';
import 'patient_profile_screen.dart';

class PatientMainShell extends StatefulWidget {
  const PatientMainShell({super.key});

  @override
  State<PatientMainShell> createState() => _PatientMainShellState();
}

class _PatientMainShellState extends State<PatientMainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PatientHomeScreen(),
    PatientChatScreen(),
    PatientDietScreen(),
    PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _screens[_currentIndex],
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
