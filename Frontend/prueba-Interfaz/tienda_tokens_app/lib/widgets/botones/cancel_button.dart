import 'package:flutter/material.dart';
import 'dart:ui';

class CancelButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CancelButton({super.key, required this.onPressed});

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.92);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,

      child: SizedBox(
        width: 160,
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ⭐ Sombra suave
            Container(
              width: 160,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),

            // ⭐ Contenedor del borde degradado
            Container(
              width: 160,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 95, 250, 201), // Verde menta
                    Color(0xFF2EB38E), // Verde profundo
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // ⭐ Fondo blanco interior + borde degradado (usamos padding para crear el borde)
            Padding(
              padding: const EdgeInsets.all(3), // grosor del borde degradado
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      borderRadius: BorderRadius.circular(50),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),

                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      onTap: widget.onPressed,

                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cancel_sharp,
                              size: 24,
                              color: Color(0xFF2EB38E), // Verde a juego
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2EB38E), // Texto verde
                              ),
                            ),
                          ],
                        ),
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
