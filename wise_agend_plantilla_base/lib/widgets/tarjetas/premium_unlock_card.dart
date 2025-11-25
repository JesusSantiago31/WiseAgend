import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PremiumUnlockCard extends StatelessWidget {
  final VoidCallback onPressed;

  const PremiumUnlockCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 105, 211, 181),
            Color.fromARGB(255, 41, 163, 129),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------------------
          // ⭐ ÍCONO PREMIUM LOTTIE
          // ------------------------------
          SizedBox(
            height: 85,
            child: Lottie.asset(
              "assets/animations/premium_unlock.json", // agrega tu archivo Lottie aquí
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 12),

          // ------------------------------
          // TITULO
          // ------------------------------
          const Text(
            "Desbloquea todas las plantillas",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // ------------------------------
          // SUBTÍTULO
          // ------------------------------
          Text(
            "Accede a plantillas premium y personaliza\n"
            "tus apuntes como nunca antes",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 14,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 18),

          // ------------------------------
          // BOTÓN PREMIUM
          // ------------------------------
          SizedBox(
            width: 210,
            height: 42,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2EB38E),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Actualizar a Premium",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
