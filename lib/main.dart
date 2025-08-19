import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/pets.dart';
import 'screens/signup.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BenjiVet',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SignupScreen(), // primeira tela será registro de usuário
    );
  }
}
