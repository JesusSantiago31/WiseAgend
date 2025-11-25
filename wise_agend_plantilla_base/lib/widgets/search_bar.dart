import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String)? onChanged;

  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Buscar por título o etiqueta...',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
