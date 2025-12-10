import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- 1. IMPORTA FIREBASE AUTH
import '../widgets/card_section.dart';
import '../interfaz/settings_option.dart';
import '../interfaz/pagos.dart';
import 'package:usuario/interfaz/editar_usuario.dart';
import 'Change_Password.dart';
import 'notificaciones.dart';
import 'package:usuario/interfaz/Pribacy_help.dart';
import '../../model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart'; // <-- 1. AÑADE ESTE IMPORT


class AccountConfigSection extends StatelessWidget {
  final UserModel user;
  // --- AÑADE ESTE CALLBACK ---
  final Function(UserModel) onProfileEdited;

  const AccountConfigSection({
    super.key,
    required this.user,
    required this.onProfileEdited, // <-- Añade al constructor
  });
  // --- 2. CREA LA FUNCIÓN PARA CERRAR SESIÓN ---
  Future<void> _signOut(BuildContext context) async {
    // Muestra un diálogo de confirmación
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar', style: TextStyle(color: Colors.black)),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),

          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Devuelve false
              child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Devuelve true
              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),

            ),
          ],
        );
      },
    );

    // Si el usuario confirmó (confirm es true), cierra la sesión
    if (confirm == true) {
      // ▼▼▼▼▼▼ REEMPLAZA ESTE BLOQUE 'try-catch' ▼▼▼▼▼▼
      try {
        // --- ESTE ES EL CAMBIO CLAVE ---
        // Hacemos el "doble logout"
        await GoogleSignIn().signOut(); // Cierra la sesión de Google
        await FirebaseAuth.instance.signOut(); // Cierra la sesión de Firebase

      } catch (e) {
        // Muestra un error si algo sale mal
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cerrar sesión: $e')),
          );
        }
      }
      // ▲▲▲▲▲▲ HASTA AQUÍ ▲▲▲▲▲▲
    }
  }
  // --- Funciones de navegación (sin cambios) ---
  void _navigateToPaymentScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PaymentScreenUI()),
    );
  }
  void _navigateToUserModel(BuildContext context, UserModel user) async {
    final result = await Navigator.of(context).push<UserModel>(
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(user: user),
      ),
    );

    // Si la pantalla de edición devolvió un resultado (un usuario actualizado)
    if (result != null) {
      onProfileEdited(result); // Llama al callback para notificar al padre
    }
  }

  void _navigateToNoti(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificacionesPage()),
    );
  }

  void _navigateToprivaci(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivacySecurityScreen()),
    );
  }

  void _navigateTohelp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SupportHelpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'Configuración de la Cuenta',
      showDivider: false,
      children: [
        // Opciones de Perfil
        SettingsOption(
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          onPressed: () => _navigateToUserModel(context, user),
        ),
        const Divider(),

        SettingsOption(
          icon: Icons.payment, // Un icono más genérico de pago
          title: 'Pagos con Google Pay',
          onPressed: () => _navigateToPaymentScreen(context),
        ),
        const Divider(),

        // Opciones de Aplicación
        SettingsOption(
          icon: Icons.notifications_none,
          title: 'Notificaciones',
          onPressed: () => _navigateToNoti(context),
        ),
        const Divider(),

        // Opciones de Privacidad y Soporte
        SettingsOption(
          icon: Icons.lock_outline,
          title: 'Privacidad y Seguridad',
          onPressed: () => _navigateToprivaci(context),
        ),
        SettingsOption(
          icon: Icons.contact_support_outlined,
          title: 'Ayuda y Soporte',
          onPressed: () => _navigateTohelp(context),
        ),
        const Divider(),

        // --- 3. ASIGNA LA FUNCIÓN AL BOTÓN ---
        SettingsOption(
          icon: Icons.logout,
          title: 'Cerrar Sesión',
          color: Colors.red,
          onPressed: () => _signOut(context), // Llama a la nueva función
        ),

        // Espacio extra para el scroll
        const SizedBox(height: 50),
      ],
    );
  }
}
