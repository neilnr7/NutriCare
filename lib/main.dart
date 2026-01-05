import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';   // <-- ADD THIS
import 'package:firebase_auth/firebase_auth.dart'; // ✅ ADD THIS


import 'screens/auth/auth_screen.dart';
import 'screens/doctor/doctor_main_shell.dart';
import 'screens/patient/patient_main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp();
  print("🔥 Firebase is connected!");

  // 🔥 CONNECT TO AUTH EMULATOR (CRITICAL)
  FirebaseAuth.instance.useAuthEmulator(
    '192.168.1.5', // 🔴 YOUR PC IP (NOT localhost)
    9099,
  );

  print("🔥 Firebase Auth Emulator connected!");

  runApp(const SamagraNutriCareApp());
}

class SamagraNutriCareApp extends StatelessWidget {
  const SamagraNutriCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samagra Nutri_Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),

        // NEW DASHBOARD SHELLS
        '/doctor-dashboard': (context) => const DoctorMainShell(),
        '/patient-dashboard': (context) => const PatientMainShell(),
      },
    );
  }
}
