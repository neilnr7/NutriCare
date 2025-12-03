import 'package:flutter/material.dart';
import '../../widgets/main_bottom_nav_bar.dart';
import 'doctor_home_screen.dart';
import 'doctor_chat_screen.dart';
import 'doctor_diet_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorMainShell extends StatefulWidget {
  const DoctorMainShell({super.key});

  @override
  State<DoctorMainShell> createState() => _DoctorMainShellState();
}

class _DoctorMainShellState extends State<DoctorMainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorHomeScreen(),
    DoctorChatScreen(),
    DoctorDietScreen(),
    DoctorProfileScreen(),
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
