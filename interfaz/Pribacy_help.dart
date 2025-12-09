// lib/widgets/Pribacy_help.dart
import 'package:flutter/material.dart';
import 'package:usuario/services/user_service.dart';
import 'package:usuario/widgets/card_section.dart';
import 'package:usuario/interfaz/settings_option.dart';
import '../widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usuario/interfaz/iniciar_secion.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final UserService _userService = UserService();
  final _deleteAccountFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController(); // Para eliminar cuenta

  final _changePasswordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE ELIMINACIÓN DE CUENTA (EXISTENTE) ---

  void _showDeletionDialog() {
    if (_userService.isGoogleUser()) {
      _showGoogleConfirmationDialog();
    } else {
      _showPasswordConfirmationDialog();
    }
  }

  Future<void> _handleDeleteAccount({String? password}) async {
    if (Navigator.canPop(context)) Navigator.pop(context);

    setState(() => _isProcessing = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final String result = await _userService.deleteUser(password: password);

    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    if (result == "OK") {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreenUI()),
              (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cuenta eliminada permanentemente.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $result'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    _passwordController.clear();
    if (mounted) setState(() => _isProcessing = false);
  }

  void _showGoogleConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Confirmar eliminación", style: AppTheme.title.copyWith(color: Colors.red)),
        content: const Text("Se te pedirá que inicies sesión de nuevo con Google para confirmar que eres tú. ¿Deseas continuar?"),
        actions: [
          TextButton(child: const Text("Cancelar", style: TextStyle(color: Colors.black)), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _isProcessing ? null : () => _handleDeleteAccount(),
            child: const Text("Continuar y firmar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPasswordConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Confirma tu identidad", style: AppTheme.title),
        content: Form(
          key: _deleteAccountFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Por seguridad, ingresa tu contraseña para poder eliminar tu cuenta."),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF30D5A0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF30D5A0).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF30D5A0), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'La contraseña no puede estar vacía' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              _passwordController.clear();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: _isProcessing ? null : () {
              if (_deleteAccountFormKey.currentState!.validate()) {
                _handleDeleteAccount(password: _passwordController.text);
              }
            },
            child: const Text("Eliminar Cuenta"),
          ),
        ],
      ),
    );
  }

  // --- NUEVA LÓGICA PARA CAMBIAR CONTRASEÑA ---

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Cambiar contraseña", style: AppTheme.title),
        content: Form(
          key: _changePasswordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF30D5A0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF30D5A0).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF30D5A0), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF30D5A0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF30D5A0).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF30D5A0), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo requerido';
                  if (v.length < 6) return 'Debe tener al menos 6 caracteres';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar" , style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              _currentPasswordController.clear();
              _newPasswordController.clear();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            onPressed: _isProcessing ? null : _handleChangePassword,
            child: const Text("Guardar cambio"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    if (!_changePasswordFormKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    if(Navigator.canPop(context)) Navigator.pop(context); // Cierra el diálogo

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final result = await _userService.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if(mounted) Navigator.pop(context); // Cierra el indicador de carga

    if (result == "OK") {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Contraseña actualizada con éxito.'), backgroundColor: Colors.green),
        );
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ $result'), backgroundColor: Colors.red),
        );
      }
    }

    _currentPasswordController.clear();
    _newPasswordController.clear();
    if(mounted) setState(() => _isProcessing = false);
  }

  // --- OTRAS FUNCIONES (EXISTENTES) ---

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: AppTheme.title),
        content: SingleChildScrollView(child: Text(content, style: const TextStyle(fontSize: 15, height: 1.5))),
        actions: [
          TextButton(child: const Text("Cerrar", style: TextStyle(color: Colors.black)), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text('Privacidad y Seguridad', style: AppTheme.title.copyWith(color: const Color(0xFF333333))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF30D5A0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CardSection(
                title: 'Gestión de la cuenta',
                showDivider: true,
                children: [
                  // --- LÓGICA CONDICIONAL EN ACCIÓN ---
                  if (_userService.isEmailPasswordUser())
                    SettingsOption(
                      icon: Icons.password,
                      color: const Color(0xFF30D5A0),
                      textColor: Colors.black,
                      title: 'Cambiar contraseña',
                      onPressed: _showChangePasswordDialog,
                    ),
                  SettingsOption(
                    icon: Icons.delete_forever_outlined,
                    color: Colors.red,
                    textColor: Colors.red,
                    title: 'Eliminar cuenta',
                    onPressed: _showDeletionDialog,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CardSection(
                title: 'Legal',
                showDivider: true,
                children: [
                  SettingsOption(
                    icon: Icons.privacy_tip_outlined,
                    color: const Color(0xFF30D5A0),
                    textColor: Colors.black,
                    title: 'Política de privacidad',
                    onPressed: () {
                      _showInfoDialog(context, "Política de privacidad",
                        '''
📌 *Última actualización: Diciembre 2025*

Esta aplicación recopila únicamente la información necesaria para el funcionamiento de tu cuenta. No compartimos datos personales con terceros sin tu consentimiento.

✔ Usamos medidas de seguridad para proteger tu información.
                        ''',
                      );
                    },
                  ),
                  SettingsOption(
                    icon: Icons.shield_outlined,
                    color: const Color(0xFF30D5A0),
                    textColor: Colors.black,
                    title: 'Términos y Condiciones',
                    onPressed: () {
                      _showInfoDialog(context, "Térmimos y Condiciones",
                        '''
📌 *Términos de uso*

Al utilizar esta aplicación aceptas los siguientes términos:

1️⃣ No usar la app para fines ilegales.
2️⃣ El usuario es responsable de la confidencialidad de sus credenciales.
3️⃣ No nos hacemos responsables por mal uso.
                        ''',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- PANTALLA DE AYUDA Y SOPORTE ---
// (Esta clase no necesita cambios y se mantiene igual)

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  void _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'soporte@tuapp.com',
      query: 'subject=Soporte Técnico&body=Hola, necesito ayuda con...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Preguntas frecuentes"),
        content: const Text(
          "• ¿Cómo restablezco mi contraseña?\n"
              "→ Ve a Configuración → Seguridad.\n\n"
              "• ¿Cómo contacto soporte?\n"
              "→ Desde este panel o por correo.\n\n"
              "• ¿Puedo eliminar mi cuenta?\n"
              "→ Sí, en Configuración → Privacidad.",
        ),
        actions: [
          TextButton(
            child: const Text("Entendido", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enviar comentarios"),
        content: TextField(
          controller: controller,
          maxLines: 1,
          decoration: InputDecoration(
            labelText: 'Escribe tu opinion',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF30D5A0)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF30D5A0).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF30D5A0), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Enviar", style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Comentario enviado 😊")),
              );
            },
          )
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Acerca de Wist Agenda"),
        content: const Text(
          "Versión 1.0.0\nDesarrollado por WistCode\n© 2025 Todos los derechos reservados.",
        ),
        actions: [
          TextButton(
            child: const Text("Cerrar", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text('Ayuda y Soporte', style: AppTheme.title.copyWith(color: const Color(0xFF333333))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF30D5A0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CardSection(
                title: 'Centro de ayuda',
                showDivider: true,
                children: [
                  SettingsOption(
                    icon: Icons.help_outline,
                    color: AppTheme.primary,
                    title: 'Preguntas frecuentes',
                    onPressed: () => _showFAQ(context),
                  ),
                  SettingsOption(
                    icon: Icons.chat_outlined,
                    color: AppTheme.primary,
                    title: 'Contacto con soporte',
                    onPressed: _openEmail,
                  ),
                  SettingsOption(
                    icon: Icons.feedback_outlined,
                    color: AppTheme.primary,
                    title: 'Enviar comentarios',
                    onPressed: () => _showFeedbackDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CardSection(
                title: 'Información',
                showDivider: true,
                children: [
                  SettingsOption(
                    icon: Icons.info_outline,
                    color: AppTheme.primary,
                    title: 'Acerca de la aplicación',
                    onPressed: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
