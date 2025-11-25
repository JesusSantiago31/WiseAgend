import 'package:flutter/material.dart';
import 'dart:ui';

class CustomProgressBar extends StatefulWidget {
  final double initialValue; // 0.0 a 1.0
  final ValueChanged<double>? onChanged;

  const CustomProgressBar({super.key, this.initialValue = 0.3, this.onChanged});

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _updateValue(double dx, double width) {
    setState(() {
      _value = (dx / width).clamp(0.0, 1.0);
    });
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;

          return GestureDetector(
            behavior: HitTestBehavior
                .translucent, // ⭐ FIX: evita bloquear otros botones
            onPanDown: (d) => _updateValue(d.localPosition.dx, barWidth),
            onPanUpdate: (d) => _updateValue(d.localPosition.dx, barWidth),

            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // ⭐ Sombra suave
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),

                  // ⭐ Borde degradado
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 95, 250, 201),
                          Color(0xFF2EB38E),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  // ⭐ Fondo blanco con blur
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              244,
                              238,
                              238,
                            ).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ⭐ Barra de progreso
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    width: barWidth * _value,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 95, 250, 201),
                          Color(0xFF2EB38E),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  // ⭐ Indicador circular (thumb)
                  Positioned(
                    left: (barWidth * _value - 16).clamp(0.0, barWidth - 32),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 95, 250, 201),
                            Color(0xFF2EB38E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),

                  // ⭐ Porcentaje
                  Center(
                    child: Text(
                      "${(_value * 100).round()}%",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 249, 250, 250),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
