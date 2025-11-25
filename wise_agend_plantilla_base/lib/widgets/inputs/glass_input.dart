import 'package:flutter/material.dart';
import 'dart:ui';

class GlassInput extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;

  const GlassInput({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  State<GlassInput> createState() => _GlassInputState();
}

class _GlassInputState extends State<GlassInput>
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
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.30),
                blurRadius: _glow.value,
                spreadRadius: 1,
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  // ⭐⭐⭐ DEGRADADO NUEVO — VISIBILIDAD GARANTIZADA ⭐⭐⭐
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(180, 255, 255, 255), // blanco fuerte
                      Color.fromARGB(160, 245, 255, 250), // verde muy suave
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  border: Border.all(
                    color: borderColor.withOpacity(0.45),
                    width: 1.5,
                  ),
                ),

                child: TextField(
                  onTap: () => _controller.forward(),
                  onTapOutside: (_) => _controller.reverse(),

                  cursorColor: borderColor,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),

                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: InputBorder.none,

                    // LABEL flotante estilo premium
                    floatingLabelStyle: const TextStyle(
                      color: borderColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),

                    labelText: widget.label,
                    labelStyle: TextStyle(
                      color: Colors.black87.withOpacity(0.7),
                      fontSize: 16,
                    ),

                    hintText: widget.hint,
                    hintStyle: TextStyle(color: Colors.grey.shade600),

                    prefixIcon: Icon(widget.icon, color: borderColor, size: 26),

                    contentPadding: const EdgeInsets.symmetric(vertical: 22),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
