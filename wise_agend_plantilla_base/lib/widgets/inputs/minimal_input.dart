import 'package:flutter/material.dart';

class MinimalInput extends StatefulWidget {
  final IconData icon;
  final String label;

  const MinimalInput({super.key, required this.icon, required this.label});

  @override
  State<MinimalInput> createState() => _MinimalInputState();
}

class _MinimalInputState extends State<MinimalInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => setState(() => _focused = focus),
        child: TextField(
          style: const TextStyle(color: Color.fromARGB(255, 14, 14, 14)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),

            // ---------- ÍCONO ANIMADO ----------
            prefixIcon: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _focused ? 1 : 0.7,
              child: Icon(widget.icon, color: const Color(0xFF34D1A1)),
            ),

            // ---------- LABEL ----------
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _focused
                  ? const Color(0xFF34D1A1)
                  : const Color.fromARGB(179, 13, 13, 13),
              letterSpacing: 0.3,
            ),

            // ---------- LÍNEA INFERIOR ----------
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF34D1A1), width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(137, 15, 13, 13),
                width: 1.3,
              ),
            ),

            // ---------- GLOW SUTIL AL ENFOCAR ----------
            // (sin cambiar color)
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: _focused
                    ? const Color(0xFF34D1A1).withOpacity(0.6)
                    : Colors.white54,
                width: _focused ? 3 : 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
