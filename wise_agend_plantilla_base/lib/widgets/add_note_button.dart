import 'package:flutter/material.dart';
import 'dart:ui';

class AddNoteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddNoteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sombra suave abajo
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

          // Botón principal con blur (glass)
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
                  onTap: onPressed,
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      size: 34,
                      color: Colors.white,
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
