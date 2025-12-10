// lib/widgets/inf_user_conf.dart

import 'package:flutter/material.dart';
import 'package:usuario/model/user_model.dart';
import 'package:usuario/interfaz/editar_usuario.dart'; // Asegúrate de que este es el nombre correcto de tu archivo de edición
import '../widgets/theme.dart';

// =========================================================================
// WIDGET PARA MOSTRAR LA INFORMACIÓN BÁSICA DEL USUARIO (AVATAR, NOMBRE, MONEDAS)
// =========================================================================
class UserHeader extends StatelessWidget {
  final String nombre;
  final int monedas;
  final String? avatar;

  const UserHeader({
    super.key,
    required this.nombre,
    required this.monedas,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // --- AVATAR DEL USUARIO ---
        CircleAvatar(
          radius: 35,
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          // Usamos un NetworkImage con manejo de errores, es más robusto.
          backgroundImage: (avatar != null && avatar!.isNotEmpty)
              ? NetworkImage(avatar!)
              : null,
          child: (avatar == null || avatar!.isEmpty)
              ? Icon(Icons.person, size: 40, color: AppTheme.primary)
              : null,
        ),
        const SizedBox(width: 15),

        // --- INFORMACIÓN DEL USUARIO ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre,
                style: AppTheme.title.copyWith(
                  fontSize: 20,
                  color: AppTheme.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // --- MONEDAS ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.monetization_on, color: AppTheme.accent, size: 20),
              const SizedBox(width: 6),
              Text(
                '$monedas',
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET PARA LAS SECCIONES DE CONFIGURACIÓN (CUENTA, AYUDA, ETC.)
// =========================================================================
class AccountConfigSection extends StatelessWidget {
  final UserModel user;
  final Function(UserModel) onProfileEdited; // Callback para notificar cambios

  const AccountConfigSection({
    super.key,
    required this.user,
    required this.onProfileEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CUENTA',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        _buildSectionContainer(
          context,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.edit_outlined,
              title: 'Editar Perfil',
              onPressed: () async { // Convertido a async para esperar el resultado
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Navegamos a la pantalla de edición
                    builder: (context) => ProfileEditScreen(user: user),
                  ),
                );

                // Si al volver recibimos un UserModel, llamamos a la función para actualizar la UI
                if (result is UserModel) {
                  onProfileEdited(result);
                }
              },
            ),
            // Si tienes una pantalla de "Privacidad", puedes descomentar esto
            // _buildDivider(),
            // _buildSettingsTile(
            //   context,
            //   icon: Icons.shield_outlined,
            //   title: 'Privacidad y Seguridad',
            //   onPressed: () {
            //     // Aquí iría la navegación a tu pantalla de privacidad
            //   },
            // ),
          ],
        ),
        const SizedBox(height: 30),
        // Aquí podrías agregar más secciones de configuración
      ],
    );
  }

  // Widget de ayuda para crear el contenedor de las secciones
  Widget _buildSectionContainer(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Widget de ayuda para crear cada opción de configuración
  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.body.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de ayuda para crear el divisor
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 54.0),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}
