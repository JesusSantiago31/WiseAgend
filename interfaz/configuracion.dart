// lib/configuracion.dart

import 'package:flutter/material.dart';
import 'package:usuario/controllers/redirecciones_paginas.dart';
import 'package:usuario/services/user_service.dart';
import '../model/user_model.dart';
import '../controllers/inf_user_conf.dart' hide AccountConfigSection;
// Asegúrate de que este import sea correcto, lo he deducido del código anterior
import 'package:usuario/interfaz/editar_usuario.dart';

class SettingsScreenUI extends StatefulWidget {
  final String idUsuario;
  const SettingsScreenUI({super.key, required this.idUsuario});

  @override
  State<SettingsScreenUI> createState() => _SettingsScreenUIState();
}

class _SettingsScreenUIState extends State<SettingsScreenUI> {
  final UserService _userService = UserService();

  // Usaremos esta variable para mantener el estado actual del usuario
  UserModel? _currentUser;

  // Usaremos un Future para la carga inicial
  late Future<void> _loadUserFuture;

  @override
  void initState() {
    super.initState();
    // El Future ahora solo carga el usuario en nuestra variable de estado
    _loadUserFuture = _loadInitialUser();
  }

  // Función para cargar los datos iniciales
  Future<void> _loadInitialUser() async {
    _currentUser = await _userService.getUser(widget.idUsuario);
  }

  // ¡LA FUNCIÓN CLAVE! Esta se llamará desde la pantalla de edición.
  // Actualiza el estado del usuario y fuerza una reconstrucción de la pantalla.
  void _handleProfileUpdate(UserModel updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF30D5A0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadUserFuture,
        builder: (context, snapshot) {
          // Mientras carga la primera vez
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF30D5A0)));
          }

          // Si hubo un error en la carga inicial
          if (snapshot.hasError || _currentUser == null) {
            return Center(child: Text("Ocurrió un error al cargar el perfil: ${snapshot.error}"));
          }

          // Si llegamos aquí, _currentUser tiene datos. Mostramos la UI.
          final user = _currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserHeader(nombre: user.nombre, monedas: user.monedas, avatar: user.avatar),
                const SizedBox(height: 30),
                AccountConfigSection(
                  user: user,
                  // Pasamos la función de callback al widget hijo
                  onProfileEdited: _handleProfileUpdate,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
