import 'package:flutter/material.dart';
import 'dart:ui';

class AnimatedNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  icon: Icons.calendar_month,
                  index: 0,
                  label: "Mi Agenda",
                ),
                _navItem(
                  icon: Icons.note_alt_rounded,
                  index: 1,
                  label: "Mis Notas",
                ),
                _navItem(
                  icon: Icons.monetization_on_outlined,
                  index: 2,
                  label: "Mis Gastos",
                ),
                _navItem(icon: Icons.eco_sharp, index: 3, label: "Mis Hábitos"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final bool active = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: active ? 18 : 10,
          vertical: active ? 8 : 4,
        ),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2EB38E).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: active ? 28 : 24,
              color: active ? const Color(0xFF2EB38E) : Colors.grey[600],
            ),
            if (active) ...[
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: active ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF2EB38E),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
