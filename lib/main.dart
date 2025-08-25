import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const BenjiVetApp());
}

class BenjiVetApp extends StatelessWidget {
  const BenjiVetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BenjiVet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
