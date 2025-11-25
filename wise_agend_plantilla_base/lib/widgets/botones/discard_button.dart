import 'package:flutter/material.dart';
import 'dart:ui';

class DiscardButton extends StatefulWidget {
  final VoidCallback onPressed;

  const DiscardButton({super.key, required this.onPressed});

  @override
  State<DiscardButton> createState() => _DiscardButtonState();
}

class _DiscardButtonState extends State<DiscardButton> {
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
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),

            // ⭐ Botón con blur + gradiente ROJO/NARANJA
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
                      colors: [
                        Color(0xFFFF5A5A), // rojo vibrante
                        Color(0xFFFF8A4D), // naranja cálido
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                            Icons.delete_forever_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Descartar",
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
