import 'package:flutter/material.dart';

class RankStatusCard extends StatelessWidget {
  final String rankTitle;
  final String nextRankTitle;
  final int currentTokens;
  final int requiredTokens;
  final int level;
  final String missingText;

  const RankStatusCard({
    super.key,
    required this.rankTitle,
    required this.nextRankTitle,
    required this.currentTokens,
    required this.requiredTokens,
    required this.level,
    required this.missingText,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentTokens / requiredTokens).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- HEADER ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Rango actual",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // ---------- NIVEL ----------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Nivel $level",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ---------- TITULO DE RANGO ----------
          Text(
            rankTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          // ---------- PROGRESO ----------
          Row(
            children: [
              // <- Expanded evita overflow
              Expanded(
                child: Text(
                  "Progreso a $nextRankTitle",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis, // evita desbordar
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "$currentTokens / $requiredTokens tokens",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---------- BARRA DE PROGRESO ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: 10,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---------- TEXTO FINAL ----------
          Text(
            missingText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
