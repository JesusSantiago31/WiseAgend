import 'package:flutter/material.dart';
import 'dart:ui';

class ExportButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ExportButton({super.key, required this.onPressed});

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails d) => setState(() => _scale = 0.92);
  void _onTapUp(TapUpDetails d) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,

      child: SizedBox(
        width: 150,
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ⭐ Sombra suave
            Container(
              width: 170,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),

            // ⭐ Botón con blur + degradado azul
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF30D5A0), Color(0xFF2EB38E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),

                    // Animación de presión
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,

                    onTap: widget.onPressed,

                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Exportar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
