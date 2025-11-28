import 'package:flutter/material.dart';

class PremiumInput extends StatefulWidget {
  final IconData icon;
  final String label;

  const PremiumInput({super.key, required this.icon, required this.label});

  @override
  State<PremiumInput> createState() => _PremiumInputState();
}

class _PremiumInputState extends State<PremiumInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,

      // ---- EFECTO PROFESIONAL ----
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),

        // Glow muy suave al enfocar
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: const Color(0xFF34D1A1).withOpacity(0.18),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
        border: Border.all(
          color: _focused
              ? const Color(0xFF34D1A1)
              : const Color.fromARGB(255, 14, 14, 14).withOpacity(0.25),
          width: _focused ? 1.8 : 1.2,
        ),
      ),

      child: Row(
        children: [
          // ---- ÍCONO PREMIUM ----
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _focused
                  ? const Color(0xFF34D1A1).withOpacity(0.20)
                  : const Color.fromARGB(255, 16, 9, 9).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, color: const Color(0xFF34D1A1), size: 20),
          ),

          const SizedBox(width: 14),

          // ---- TEXTFIELD SIN BORDES ----
          Expanded(
            child: Focus(
              onFocusChange: (f) => setState(() => _focused = f),
              child: TextField(
                style: const TextStyle(color: Color.fromARGB(255, 15, 13, 13)),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                    color: _focused
                        ? const Color(0xFF34D1A1)
                        : const Color.fromARGB(
                            255,
                            26,
                            25,
                            25,
                          ).withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                ),
                cursorColor: const Color(0xFF34D1A1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
