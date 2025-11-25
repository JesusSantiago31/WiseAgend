import 'package:flutter/material.dart';
import 'dart:ui';

class AddNoteButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddNoteButton({super.key, required this.onPressed});

  @override
  State<AddNoteButton> createState() => _AddNoteButtonState();
}

class _AddNoteButtonState extends State<AddNoteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    _controller.forward(from: 0); // reinicia y ejecuta la animación
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ⭐ Sombra circular suave
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // ⭐ Botón principal con blur + gradiente
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF30D5A0), Color(0xFF2EB38E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _animate,

                  // ⭐ Animación de giro
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 3.14 * 0.5, // 360°
                          child: child,
                        );
                      },
                      child: const Icon(
                        Icons.add_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
