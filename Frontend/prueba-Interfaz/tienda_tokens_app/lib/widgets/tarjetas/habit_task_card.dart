import 'package:flutter/material.dart';

class HabitTaskCard extends StatelessWidget {
  final IconData icon;
  final String category;
  final String title;
  final double progress; // 0.0 a 1.0
  final List<String> days;
  final int calories;
  final String time;
  final int percent;
  final int views;

  const HabitTaskCard({
    super.key,
    required this.icon,
    required this.category,
    required this.title,
    required this.progress,
    required this.days,
    required this.calories,
    required this.time,
    required this.percent,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF6B6B); // rojo suave del borde
    const softRed = Color(0xFFFFE8E8); // fondo chips
    const dark = Color(0xFF111111);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: const Border(
          left: BorderSide(color: Color.fromARGB(255, 84, 203, 173), width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: softRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primary, size: 20),
              ),

              const SizedBox(width: 10),

              Text(
                category,
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------------- TITLE ----------------
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  color: dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------------- PROGRESS BAR ----------------
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: softRed.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: dark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // ---------------- DAYS TAGS ----------------
          Wrap(
            spacing: 8,
            children: days.map((d) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  d,
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // ---------------- FOOTER METRICS ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric(Icons.local_fire_department, "$calories"),
              _metric(Icons.access_time_filled_rounded, time),
              _metric(Icons.battery_5_bar_rounded, "$percent%"),
              _metric(Icons.visibility, "$views"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
