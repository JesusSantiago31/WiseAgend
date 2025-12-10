  import 'package:flutter/material.dart';

  class CardSection extends StatelessWidget {
    final String? title; // 👈 ahora es opcional
    final List<Widget> children;
    final bool showDivider;

    const CardSection({
      super.key,
      this.title, // 👈 ya no es obligatorio
      required this.children,
      this.showDivider = true,
    });

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[  // 👈 solo se muestra si hay título
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                if (showDivider) const Divider(height: 25),
              ],
              ...children,
            ],
          ),
        ),
      );
    }
  }
