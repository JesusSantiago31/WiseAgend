import 'package:flutter/material.dart';
import 'dart:ui';

class CompleteButton extends StatefulWidget {
  final VoidCallback onPressed; // ⬅️ SE AGREGA el parámetro requerido

  const CompleteButton({super.key, required this.onPressed});

  @override
  State<CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<CompleteButton> {
  bool _completed = false; // Estado del botón
  double _scale = 1.0;

  void _onTapDown(TapDownDetails d) {
    setState(() => _scale = 0.92);
  }

  void _onTapUp(TapUpDetails d) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  void _toggleState() {
    setState(() => _completed = !_completed);
    widget.onPressed(); // ⬅️ Ejecuta acción externa
  }

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
              width: 150,
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 150,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 95, 250, 201),
                    Color(0xFF2EB38E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // ⭐ Contenido interior
            Padding(
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: _completed
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 95, 250, 201),
                                Color(0xFF2EB38E),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),

                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      onTap:
                          _toggleState, // ⬅️ Alterna estado + onPressed externo

                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _completed
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 26,
                              color: _completed
                                  ? Colors.white
                                  : const Color(0xFF2EB38E),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _completed ? "Completado" : "Completar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _completed
                                    ? Colors.white
                                    : const Color(0xFF2EB38E),
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
