// lib/widgets/iniciar_secion.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:usuario/services/user_service.dart';

// --- Tus widgets CustomLoginButton y LogoWidget se quedan igual ---
class CustomLoginButton extends StatelessWidget {
  final String text;
  final Widget iconWidget;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomLoginButton({
    super.key,
    required this.text,
    required this.iconWidget,
    required this.backgroundColor,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(width: 24.0, height: 24.0, child: iconWidget),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Color(0xFF30D5A0), width: 2.0),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoginMode =
        context.findAncestorStateOfType<_LoginScreenUIState>()?._isLoginMode ??
            true;
    final logoSize = isLoginMode ? 150.0 : 120.0;

    return Column(
      children: [
        Image.asset(
          'assets/image/logo.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 15),
        Text(
          isLoginMode ? 'Bienvenido de Nuevo' : 'Crea tu Cuenta',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
// --- Fin de los widgets ---

class LoginScreenUI extends StatefulWidget {
  const LoginScreenUI({super.key});

  @override
  State<LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<LoginScreenUI> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE LOGIN CON GOOGLE ---
  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Para Google, no pasamos nombre personalizado, la función usará user.displayName
        await _userService.createUserDocument(user);
      }
      // No navegamos, el AuthGate se encargará.
    } catch (e) {
      print("ERROR LOGIN GOOGLE: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error al iniciar sesión con Google."),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- LÓGICA DE LOGIN/REGISTRO CON EMAIL Y CONTRASEÑA (CORREGIDA) ---
  Future<void> _submitForm() async {
    if (_isLoading) return;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        // Modo Login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Modo Registro
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          // 1. Leemos los controladores de texto.
          final String nombreCompleto =
              "${_nameController.text.trim()} ${_lastNameController.text.trim()}";

          // 2. Depuramos para confirmar que el nombre se lee correctamente.
          print("▶️ REGISTRO: Pasando nombre personalizado: '$nombreCompleto'");

          // 3. ¡LLAMAMOS A UserService PASANDO EL NOMBRE!
          await _userService.createUserDocument(user,
              nombrePersonalizado: nombreCompleto);
        }
      }
      // No navegamos, el AuthGate se encargará.
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error.';
      if (e.code == 'weak-password') {
        message = 'La contraseña es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo ya está registrado.';
      } else if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Correo o contraseña incorrectos.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error inesperado: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tu tema con los colorcitos :)
    final inputDecorationTheme = InputDecorationTheme(
      prefixIconColor: const Color(0xFF30D5A0),
      suffixIconColor: const Color(0xFF30D5A0),
      floatingLabelStyle: const TextStyle(color: Color(0xFF30D5A0)),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF30D5A0), width: 2),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(inputDecorationTheme: inputDecorationTheme),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const LogoWidget(),
                    const SizedBox(height: 25),

                    // --- CAMPOS DE REGISTRO ---
                    if (!_isLoginMode) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre(s)',
                            prefixIcon: Icon(Icons.person_outline)),
                        validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            labelText: 'Apellidos',
                            prefixIcon: Icon(Icons.people_outline)),
                        validator: (v) =>
                        v!.isEmpty ? 'Ingresa tus apellidos' : null,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // --- CAMPOS COMUNES (EMAIL Y PASSWORD) ---
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.alternate_email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Ingresa un correo válido'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) =>
                      (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 12),
                    if (!_isLoginMode)
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            prefixIcon: Icon(Icons.lock_outline)),
                        validator: (v) => (v != _passwordController.text)
                            ? 'Las contraseñas no coinciden'
                            : null,
                      ),
                    const SizedBox(height: 25),

                    // --- BOTONES (CON LA LÓGICA DE CARGA) ---
                    if (_isLoading)
                      const CircularProgressIndicator(color: Color(0xFF30D5A0))
                    else
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF30D5A0),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                _isLoginMode ? 'Iniciar Sesión' : 'Crear Cuenta',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_isLoginMode) ...[
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('O')),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomLoginButton(
                              text: 'Continuar con Google',
                              iconWidget: Image.asset('assets/image/google.png'),
                              backgroundColor: Colors.white,
                              onPressed: _handleGoogleLogin,
                            ),
                          ],
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (!_isLoading)
                      TextButton(
                        onPressed: () =>
                            setState(() => _isLoginMode = !_isLoginMode),
                        child: Text(
                          _isLoginMode
                              ? '¿No tienes cuenta? Regístrate'
                              : '¿Ya tienes cuenta? Inicia Sesión',
                          style: const TextStyle(
                              color: Color(0xFF30D5A0),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
