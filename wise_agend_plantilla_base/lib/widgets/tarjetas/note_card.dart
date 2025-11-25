import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String date;
  final bool share;
  final bool isFavorite;

  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.date,
    this.share = false,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: title + share icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              if (share) const Icon(Icons.share, size: 18, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(color: Colors.grey.shade700, height: 1.2),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: Color(0xFF2EB38E),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              Icon(
                Icons.star,
                color: isFavorite ? Colors.amber : Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
