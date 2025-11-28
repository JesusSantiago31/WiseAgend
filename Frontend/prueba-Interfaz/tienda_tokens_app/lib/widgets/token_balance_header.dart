import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class TokenBalanceHeader extends StatelessWidget {
  final String userName;
  final int tokens;
  const TokenBalanceHeader({super.key, required this.userName, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.mintStrong, AppColors.mintAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tienda de Recompensas', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Hola, $userName', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Icon(Icons.monetization_on, color: AppColors.mintStrong),
              const SizedBox(width: 8),
              Text('$tokens', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold)),
            ]),
          )
        ],
      ),
    );
  }
}