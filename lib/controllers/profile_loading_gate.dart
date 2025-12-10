// lib/profile_loading_gate.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usuario/interfaz/configuracion.dart'; // Tu pantalla principal

class ProfileLoadingGate extends StatelessWidget {
  final String userId;

  const ProfileLoadingGate({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Se suscribe a los cambios del documento del usuario.
      stream: FirebaseFirestore.instance.collection('usuarios').doc(userId).snapshots(),
      builder: (context, snapshot) {
        // Muestra un spinner mientras espera la primera respuesta de Firestore.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF30D5A0))),
          );
        }

        // Si el snapshot tiene datos y el documento EXISTE...
        if (snapshot.hasData && snapshot.data!.exists) {
          // ...¡Éxito! Lo mandamos a la pantalla principal.
          return SettingsScreenUI(idUsuario: userId);
        }

        // Si llega aquí, significa que el snapshot NO tiene datos o el documento NO existe aún.
        // En lugar de mostrar un error o una pantalla estática, mostramos un spinner.
        // El StreamBuilder seguirá escuchando y cuando el documento finalmente se cree,
        // reconstruirá este widget y entrará en el `if` de arriba.
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF30D5A0)),
                SizedBox(height: 16),
                Text("Cargando perfil..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
