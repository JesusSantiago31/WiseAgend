import 'package:flutter/material.dart';

class GlowInput extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;

  const GlowInput({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  State<GlowInput> createState() => _GlowInputState();
}

class _GlowInputState extends State<GlowInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _glow = Tween<double>(
      begin: 0,
      end: 18,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF2EB38E);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.35),
                blurRadius: _glow.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextField(
            onTap: () => _controller.forward(),
            onTapOutside: (_) => _controller.reverse(),

            cursorColor: borderColor,
            style: const TextStyle(color: Colors.black87),

            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,

              // ⭐ evita que la etiqueta suba demasiado
              floatingLabelStyle: TextStyle(
                color: const Color.fromARGB(255, 10, 11, 11),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),

              labelText: widget.label,
              labelStyle: const TextStyle(color: Colors.black54, fontSize: 16),

              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey.shade500),

              prefixIcon: Icon(widget.icon, color: borderColor),

              filled: true,
              fillColor: Colors.white,

              // ⭐ padding ajustado para que la etiqueta NO se encime
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: borderColor.withOpacity(0.25),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: borderColor, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
