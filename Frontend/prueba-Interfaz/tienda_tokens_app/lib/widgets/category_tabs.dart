import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;
  const CategoryTabs({super.key, required this.categories, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_,__) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final c = categories[index];
          final active = c == selected;
          return GestureDetector(
            onTap: () => onSelect(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.mint : AppColors.pale,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.mintStrong.withOpacity(0.6)),
              ),
              child: Center(child: Text(c, style: TextStyle(color: active ? AppColors.darkGreen : AppColors.textPrimary))),
            ),
          );
        },
      ),
    );
  }
}