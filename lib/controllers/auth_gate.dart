// lib/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usuario/interfaz/iniciar_secion.dart';
import 'package:usuario/controllers/profile_loading_gate.dart'; // <-- IMPORTA EL NUEVO WIDGET

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si hay un usuario autenticado...
        if (snapshot.hasData) {
          // ...NO vamos directo a la pantalla principal.
          // Primero, vamos a nuestro widget de carga, que verificará
          // que el perfil en Firestore esté listo.
          return ProfileLoadingGate(userId: snapshot.data!.uid);
        }
        // Si no hay usuario...
        else {
          // Muestra la pantalla de inicio de sesión (esto no cambia).
          return const LoginScreenUI();
        }
      },
    );
  }
}
