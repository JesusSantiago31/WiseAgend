// lib/widgets/email_login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true; // Para alternar entre Login y Registro
  bool _isLoading = false;

  // Función principal para manejar el login o el registro
  Future<void> _submitAuthForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // --- LÓGICA DE INICIO DE SESIÓN ---
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // --- LÓGICA DE REGISTRO ---
        // 1. Crear usuario en Firebase Auth
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;
        if (user == null) return;

        // 2. Guardar datos adicionales en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          "id_usuario": user.uid,
          "nombre": "Usuario", // Nombre por defecto
          "correo": user.email,
          "avatar": "", // Sin avatar al inicio
          "rango": "principiante",
          "monedas": 0,
          "nivel": 1,
          "tipo_cuenta": "free",
          "fecha_registro": DateTime.now().toIso8601String(),
          "notificaciones": { // Notificaciones por defecto
            "generales": true, "promociones": false, "actualizaciones": true, "recordatorios": true
          },
        });
      }

      // Si llegamos aquí, el login/registro fue exitoso.
      // El AuthGate nos redirigirá automáticamente. No necesitamos hacer pop.

    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error';
      if (e.code == 'weak-password') {
        message = 'La contraseña es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo electrónico ya está en uso.';
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Credenciales incorrectas.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error inesperado: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'),
        backgroundColor: const Color(0xFF30D5A0), // Color de tu app
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de Correo Electrónico
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) => (value == null || !value.contains('@')) ? 'Por favor, ingresa un correo válido.' : null,
                ),
                const SizedBox(height: 12),
                // Campo de Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) => (value == null || value.length < 6) ? 'La contraseña debe tener al menos 6 caracteres.' : null,
                ),
                const SizedBox(height: 30),
                // Botón principal (Login o Registro)
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submitAuthForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF30D5A0),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta', style: const TextStyle(color: Colors.white)),
                  ),
                const SizedBox(height: 12),
                // Botón para cambiar entre Login y Registro
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin ? '¿No tienes cuenta? Regístrate aquí' : '¿Ya tienes cuenta? Inicia sesión',
                    style: const TextStyle(color: Color(0xFF30D5A0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
