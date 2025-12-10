// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/auth_gate.dart'; // <-- PASO 1: IMPORTA EL NUEVO ARCHIVO

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wist Agenda UI',
      debugShowCheckedModeBanner: false,
      home: AuthGate(), // <-- PASO 2: USA AuthGate COMO PANTALLA PRINCIPAL
    );
  }
}
