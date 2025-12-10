import 'package:flutter/material.dart';
// ¡NUEVO IMPORT! Para renderizar texto con formato
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:usuario/services/user_service.dart';
import 'package:usuario/widgets/card_section.dart';
import 'package:usuario/interfaz/settings_option.dart';
import '../widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usuario/interfaz/iniciar_secion.dart';

// --- Textos Legales Profesionales (Formato Markdown Mejorado) ---

const String _privacyPolicyText = """
**Política de Privacidad de Wist Agenda**

*Última actualización: 8 de diciembre de 2025*

En WistCode ("nosotros", "nuestro"), respetamos tu privacidad y nos comprometemos a proteger tus datos personales. Esta política de privacidad te informará sobre cómo cuidamos tus datos cuando utilizas nuestra aplicación Wist Agenda (la "App") y te informará sobre tus derechos de privacidad y cómo la ley te protege.

### 1. Datos que Recopilamos

Para proporcionarte nuestros servicios, recopilamos y procesamos los siguientes datos:

- **Información de Identificación Personal:** Nombre, dirección de correo electrónico y una contraseña cifrada. Si te registras con un proveedor externo como Google, almacenamos tu nombre, correo y un identificador único de esa cuenta.
- **Contenido del Usuario:** Cualquier información que introduzcas voluntariamente en la App, como notas, recordatorios, eventos del calendario, datos financieros, seguimiento de hábitos y cualquier otro contenido que crees o subas.
- **Datos de Uso y Técnicos:** Información sobre cómo accedes y utilizas la App, incluyendo tu tipo de dispositivo, identificadores únicos del dispositivo, dirección IP, sistema operativo e información sobre fallos de la aplicación. Esta información es anónima y se utiliza para mejorar la estabilidad y el rendimiento.

### 2. Cómo Utilizamos tus Datos

Utilizamos la información que recopilamos para:

- Proveer, operar y mantener nuestra App.
- Mejorar, personalizar y expandir nuestros servicios.
- Entender y analizar cómo utilizas nuestra App para optimizar la experiencia de usuario.
- Gestionar tu cuenta, incluyendo la autenticación y la aplicación de tus preferencias.
- Procesar tus transacciones y gestionar suscripciones (si aplica).
- Comunicarnos contigo para proporcionarte soporte al cliente, actualizaciones y otra información relacionada con la App.
- Prevenir el fraude y garantizar la seguridad de nuestra plataforma.

### 3. Cómo Compartimos tu Información

Tu privacidad es nuestra prioridad. **No vendemos, alquilamos ni compartimos tu información personal con terceros**, excepto en las siguientes circunstancias:

- **Con tu Consentimiento Explícito:** Compartiremos tu información si nos das permiso para hacerlo.
- **Proveedores de Servicios:** Podemos compartir información con empresas de terceros que nos ayudan a operar nuestra App (como proveedores de hosting en la nube y procesadores de pago), quienes están **obligados contractualmente** a proteger tu información y usarla solo para los fines para los que se la revelamos.
- **Requisitos Legales:** Podemos divulgar tu información si así lo exige la ley o en respuesta a solicitudes válidas de autoridades públicas.

### 4. Seguridad de los Datos

Hemos implementado medidas de seguridad técnicas y organizativas apropiadas para evitar que tus datos personales se pierdan accidentalmente, se usen o se accedan de forma no autorizada. Esto incluye el cifrado de datos en tránsito y en reposo.

### 5. Eliminación de tu Cuenta y Datos

Tienes derecho a eliminar tu cuenta en cualquier momento desde la sección "Privacidad y Seguridad" de la App. Al hacerlo, **eliminaremos de forma permanente** toda tu información personal y contenido de usuario de nuestros sistemas activos.

### 6. Contacto

Si tienes alguna pregunta sobre esta Política de Privacidad, puedes contactarnos en: **soporte.wistcode@email.com**
""";

const String _termsAndConditionsText = """
**Términos y Condiciones de Uso de Wist Agenda**

*Última actualización: 8 de diciembre de 2025*

Bienvenido a Wist Agenda. Estos términos y condiciones describen las reglas y regulaciones para el uso de la aplicación Wist Agenda, desarrollada por WistCode.

Al acceder y utilizar esta App, asumimos que aceptas estos términos y condiciones en su totalidad. **No continúes usando Wist Agenda si no estás de acuerdo con todos los términos establecidos en esta página.**

### 1. Licencia de Uso

Se te concede una licencia limitada, no exclusiva, intransferible y revocable para descargar, instalar y utilizar la App estrictamente de acuerdo con estos Términos.

**No debes:**
- Sublicenciar, vender o alquilar material de la App.
- Usar la App para fines ilegales, fraudulentos o dañinos.
- Realizar ingeniería inversa, descompilar o intentar extraer el código fuente de la App.

### 2. Cuentas de Usuario y Contenido

- Eres el **único responsable** de la actividad que ocurre en tu cuenta y debes mantener la confidencialidad de tu contraseña.
- Tú retienes todos los derechos de propiedad sobre tu contenido. Al crear o subir contenido a la App, nos otorgas una licencia mundial, no exclusiva y libre de regalías para usar, alojar, almacenar, reproducir y modificar dicho contenido con el único propósito de operar y proporcionarte los servicios de la App.

### 3. Cuentas Premium y Pagos

- Ofrecemos funciones mejoradas a través de suscripciones de pago ("Cuenta Premium").
- Todos los pagos realizados a través de la Google Play Store están sujetos a los términos y condiciones de Google. Eres responsable de pagar todas las tarifas e impuestos aplicables.
- Las suscripciones se renuevan automáticamente a menos que se cancelen antes del final del período de facturación actual. Puedes gestionar o cancelar tu suscripción a través de la configuración de tu cuenta de Google Play.

### 4. Limitación de Responsabilidad

- La App se proporciona **"tal cual" y "según disponibilidad"**. No garantizamos que la App estará libre de errores o disponible ininterrumpidamente.
- En la máxima medida permitida por la ley, WistCode **no será responsable** de ningún daño indirecto, incidental, especial, consecuente o punitivo, o de cualquier pérdida de datos o beneficios.

### 5. Terminación

- Podemos suspender o cancelar tu acceso a la App de inmediato, sin previo aviso, por cualquier motivo, incluido el incumplimiento de estos Términos.
- Puedes cancelar tu cuenta en cualquier momento eliminándola desde la configuración de la App.

### 6. Modificaciones a los Términos

Nos reservamos el derecho de modificar o reemplazar estos Términos en cualquier momento. Te notificaremos sobre cualquier cambio actualizando la fecha de "Última actualización".

### 7. Contacto

Si tienes alguna pregunta sobre estos Términos, contáctanos en: **soporte.wistcode@email.com**
""";

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final UserService _userService = UserService();
  final _deleteAccountFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

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

  // --- LÓGICA DE ELIMINACIÓN DE CUENTA ---
  // ... (Toda esta sección de lógica de eliminación y cambio de contraseña se mantiene exactamente igual)
  void _showDeletionDialog() {
    if (_userService.isGoogleUser()) {
      _showGoogleConfirmationDialog();
    } else {
      _showPasswordConfirmationDialog();
    }
  }

  Future<void> _handleDeleteAccount({String? password}) async {
    // Cerrar el diálogo de confirmación actual
    if (Navigator.canPop(context)) Navigator.pop(context);

    setState(() => _isProcessing = true);
    // Mostrar un indicador de carga central
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final String result = await _userService.deleteUser(password: password);

    // Cerrar el indicador de carga
    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    if (result == "OK") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cuenta eliminada permanentemente.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreenUI()),
              (Route<dynamic> route) => false,
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
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
        title: Text("Confirmar eliminación", style: AppTheme.title.copyWith(color: Colors.red.shade700)),
        content: const Text("Para confirmar la eliminación permanente de tu cuenta y todos tus datos, se te pedirá que vuelvas a iniciar sesión con Google. ¿Deseas continuar?"),
        actions: [
          TextButton(child: const Text("Cancelar", style: TextStyle(color: Colors.black54)), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: _isProcessing ? null : () => _handleDeleteAccount(),
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }

  void _showPasswordConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
        title: Text("Confirma tu identidad", style: AppTheme.title),
        content: Form(
          key: _deleteAccountFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Por seguridad, ingresa tu contraseña para poder eliminar tu cuenta y todos tus datos de forma permanente."),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  border: OutlineInputBorder(borderRadius: AppTheme.borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primary, width: 2.0),
                    borderRadius: AppTheme.borderRadius,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'La contraseña no puede estar vacía' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.black54)),
            onPressed: () {
              Navigator.pop(context);
              _passwordController.clear();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: _isProcessing ? null : () {
              if (_deleteAccountFormKey.currentState?.validate() ?? false) {
                _handleDeleteAccount(password: _passwordController.text);
              }
            },
            child: const Text("Eliminar Cuenta"),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA PARA CAMBIAR CONTRASEÑA ---

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
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
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.lock_open_outlined, color: AppTheme.primary),
                  border: OutlineInputBorder(borderRadius: AppTheme.borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primary, width: 2.0),
                    borderRadius: AppTheme.borderRadius,
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
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  border: OutlineInputBorder(borderRadius: AppTheme.borderRadius),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primary, width: 2.0),
                    borderRadius: AppTheme.borderRadius,
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
            child: const Text("Cancelar" , style: TextStyle(color: Colors.black54)),
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
    if (!(_changePasswordFormKey.currentState?.validate() ?? false)) return;

    if(Navigator.canPop(context)) Navigator.pop(context); // Cierra el diálogo
    setState(() => _isProcessing = true);

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


  // --- FUNCIÓN MEJORADA PARA MOSTRAR TEXTOS LEGALES ---
  void _showLegalDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
        title: Text(title, style: AppTheme.title),
        // --- ¡CAMBIO CLAVE AQUÍ! ---
        // Usamos el widget MarkdownBody para renderizar el texto formateado
        content: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                h3: AppTheme.title.copyWith(fontSize: 16, height: 2.0),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              child: const Text("Cerrar", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(context)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... El resto del widget `build` se mantiene exactamente igual
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Privacidad y Seguridad', style: AppTheme.title.copyWith(color: AppTheme.textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CardSection(
                title: 'Gestión de la cuenta',
                children: [
                  if (_userService.isEmailPasswordUser())
                    SettingsOption(
                      icon: Icons.password_rounded,
                      color: AppTheme.primary,
                      title: 'Cambiar contraseña',
                      onPressed: _showChangePasswordDialog,
                    ),
                  SettingsOption(
                    icon: Icons.no_accounts_rounded,
                    color: Colors.red.shade700,
                    textColor: Colors.red.shade700,
                    title: 'Eliminar cuenta permanentemente',
                    onPressed: _showDeletionDialog,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CardSection(
                title: 'Legal y Cumplimiento',
                children: [
                  SettingsOption(
                    icon: Icons.privacy_tip_outlined,
                    color: AppTheme.primary,
                    title: 'Política de Privacidad',
                    onPressed: () {
                      _showLegalDialog(context, "Política de Privacidad", _privacyPolicyText);
                    },
                  ),
                  SettingsOption(
                    icon: Icons.gavel_rounded,
                    color: AppTheme.primary,
                    title: 'Términos y Condiciones',
                    onPressed: () {
                      _showLegalDialog(context, "Términos y Condiciones", _termsAndConditionsText);
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

// ... La clase SupportHelpScreen se mantiene igual.
// --- PANTALLA DE AYUDA Y SOPORTE ---

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  // --- MÉTODOS DE LA CLASE ---

  // Función auxiliar para no repetir código al abrir URLs
  Future<void> _launch(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      // Opcional: Mostrar un error si no se puede abrir el enlace
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el enlace: $url')),
        );
      }
    }
  }

  void _openEmail(BuildContext context) async {
    final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'soporte.wistcode@email.com', // Correo profesional
        queryParameters: {
          'subject': 'Soporte Wist Agenda',
          'body': 'Hola, equipo de Wist Agenda.\n\nNecesito ayuda con lo siguiente:\n\n'
        }
    );
    if (!await launchUrl(emailUri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la aplicación de correo.')),
        );
      }
    }
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
        title: Text("Preguntas Frecuentes", style: AppTheme.title),
        content: const SingleChildScrollView(
          child: Text(
            "• ¿Cómo restauro una compra o suscripción?\n"
                "→ En la pantalla de suscripción, busca la opción 'Restaurar compras'. Esto verificará tus compras previas con Google Play.\n\n"
                "• ¿Cómo contacto con soporte?\n"
                "→ Puedes usar la opción 'Contacto con soporte' en esta pantalla para enviarnos un correo directamente.\n\n"
                "• ¿Puedo usar mi cuenta en múltiples dispositivos?\n"
                "→ ¡Sí! Simplemente inicia sesión con la misma cuenta (correo y contraseña o Google) y todos tus datos se sincronizarán automáticamente.\n\n"
                "• ¿Mis datos están seguros?\n"
                "→ Absolutamente. Utilizamos cifrado y las mejores prácticas de seguridad en la nube para proteger toda tu información.",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Entendido", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
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
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
        title: Text("Envíanos tus comentarios", style: AppTheme.title),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nos encantaría saber tu opinión...',
            border: OutlineInputBorder(borderRadius: AppTheme.borderRadius),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.black54)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            child: const Text("Enviar"),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                // Aquí podrías enviar el feedback a tu backend o a un servicio de análisis
                print("Feedback del usuario: ${controller.text}");
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("¡Gracias por tus comentarios! 😊")),
                );
              }
            },
          )
        ],
      ),
    );
  }

// En la clase SupportHelpScreen

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Theme(
        // 1. Envolvemos el diálogo en un widget Theme
        data: Theme.of(context).copyWith(
          // 2. Sobrescribimos el estilo de los TextButton específicamente para este diálogo
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary, // 3. ¡Este es el cambio clave! Asigna tu color verde.
            ),
          ),
        ),
        child: AboutDialog(
          applicationIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset('assets/image/logo.png', width: 52),
          ),
          applicationName: 'Wist Agenda',
          applicationVersion: '1.0.0 (Build 20251208)',
          applicationLegalese: '© 2025 WistCode. Todos los derechos reservados.',
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 18),
              child: Text(
                'Tu asistente personal inteligente para organizar tu vida, finanzas y hábitos. Diseñado y desarrollado con ❤️ por el equipo de WistCode.',
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Image.asset(
                    'assets/image/git.png', // <-- Ruta a tu imagen del logo
                    width: 24,
                    height: 24,
                  ),
                  tooltip: 'Visita nuestra página web',
                  onPressed: () => _launch(context, 'https://github.com/WistCode'), // Cambiar por URL real
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/image/x.png', // <-- Ruta a tu imagen del logo
                    width: 24,
                    height: 24,
                  ),
                  tooltip: 'Síguenos en X',
                  onPressed: () => _launch(context, 'https://twitter.com/WistCode'), // Cambiar por URL real
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/image/facebook.png', // <-- Ruta a tu imagen del logo
                    width: 24,
                    height: 24,
                  ),
                  tooltip: 'Conecta con nosotros en Facebook',
                  onPressed: () => _launch(context, 'https://facebook.com/wistcode'), // Cambiar por URL real
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Ayuda y Soporte', style: AppTheme.title.copyWith(color: AppTheme.textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CardSection(
                title: 'Centro de Ayuda',
                children: [
                  SettingsOption(
                    icon: Icons.help_outline_rounded,
                    color: AppTheme.primary,
                    title: 'Preguntas Frecuentes (FAQ)',
                    onPressed: () => _showFAQ(context),
                  ),
                  SettingsOption(
                    icon: Icons.alternate_email_rounded,
                    color: AppTheme.primary,
                    title: 'Contacto con Soporte',
                    onPressed: () => _openEmail(context),
                  ),
                  SettingsOption(
                    icon: Icons.feedback_outlined,
                    color: AppTheme.primary,
                    title: 'Enviar Comentarios',
                    onPressed: () => _showFeedbackDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CardSection(
                title: 'Información de la App',
                children: [
                  SettingsOption(
                    icon: Icons.info_outline_rounded,
                    color: AppTheme.primary,
                    title: 'Acerca de Wist Agenda',
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
