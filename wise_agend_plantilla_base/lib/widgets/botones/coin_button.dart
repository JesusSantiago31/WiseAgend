import 'package:flutter/material.dart';
import 'dart:ui';

class CoinButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CoinButton({super.key, required this.onPressed});

  @override
  State<CoinButton> createState() => _CoinButtonState();
}

class _CoinButtonState extends State<CoinButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de rebote
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // Animación de brillo automática
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    _shineController.repeat(); // Repetir infinitamente
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward(from: 0);
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: SizedBox(
        width: 190,
        height: 60,
        child: Stack(
          children: [
            // Sombra
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),

            // Botón con gradiente y blur
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF5D142), Color(0xFFFFB800)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    child: Stack(
                      children: [
                        // Brillo animado continuo
                        AnimatedBuilder(
                          animation: _shineAnimation,
                          builder: (context, _) {
                            return FractionalTranslation(
                              translation: Offset(
                                _shineAnimation.value,
                                -_shineAnimation.value,
                              ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.0),
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Contenido del botón
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.monetization_on_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "200 Monedas",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
