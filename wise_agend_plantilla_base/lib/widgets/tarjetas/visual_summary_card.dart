import 'package:flutter/material.dart';
import 'dart:ui';
import '../botones/coin_button.dart'; // <-- importa tu CoinButton

class VisualSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool locked;
  final VoidCallback onPressed;

  const VisualSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.locked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE3F0EA).withOpacity(0.75),
                  const Color(0xFFD7EFEA).withOpacity(0.55),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ICONO + LOCK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF79AFA1).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.hub_outlined,
                        color: Color(0xFF408C73),
                        size: 30,
                      ),
                    ),
                    if (locked)
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // --- TITULO ---
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2B4D44),
                  ),
                ),

                const SizedBox(height: 6),

                // --- SUBTITULO ---
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 18),

                // --- BOTÓN DE MONEDAS ---
                Center(
                  child: CoinButton(
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
