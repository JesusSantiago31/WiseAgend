import 'package:flutter/material.dart';
import '../widgets/theme.dart';

// Widget para replicar una fila de opción de configuración
class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const SettingsOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                // <--- El 'color' principal ahora solo afecta al icono
                size: 24,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.body.copyWith(
                    // Si no se especifica un textColor, usa negro.
                    color: textColor ?? Colors.black87,
                    // <--- LÓGICA DE COLOR PARA EL TEXTO
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}