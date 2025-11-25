import 'package:flutter/material.dart';

class UserStatusCard extends StatelessWidget {
  final String username;
  final int level;
  final double progress; // 0.0 – 1.0
  final int coins;

  const UserStatusCard({
    super.key,
    required this.username,
    required this.level,
    required this.progress,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 🔥 Ya NO es height fija — ahora puede crecer sin overflow
      constraints: const BoxConstraints(
        minHeight: 120, // Altura mínima
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF5BC0A4), Color(0xFF2EB38E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // AVATAR
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
              color: Colors.white.withOpacity(0.25),
            ),
            child: Center(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : "?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          // TEXTO Y PROGRESO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // 🔥 evita overflow vertical
              children: [
                // NOMBRE + NIVEL
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        overflow: TextOverflow
                            .ellipsis, // 🔥 evita desbordes horizontales
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Nivel $level",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "${(progress * 100).toStringAsFixed(0)}% hacia el nivel ${level + 1}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 6,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "$coins monedas disponibles",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
