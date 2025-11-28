import 'package:flutter/material.dart';

class CustomInputFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const CustomInputFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedInputField(
          controller: titleController,
          label: "Título",
          icon: Icons.title,
        ),

        AnimatedInputField(
          controller: descriptionController,
          label: "Descripción",
          icon: Icons.description,
          maxLines: 4,
        ),
      ],
    );
  }
}

// ⭐️ Animaciones + íconos agregados
class AnimatedInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final IconData icon;

  const AnimatedInputField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    required this.icon,
  });

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0,
      end: 14,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF30D5A0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: borderColor.withOpacity(0.55),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            onTap: () {
              setState(() => _isFocused = true);
              _controller.forward();
            },
            onTapOutside: (_) {
              setState(() => _isFocused = false);
              _controller.reverse();
            },
            cursorColor: borderColor,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _isFocused ? borderColor : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(widget.icon, color: borderColor, size: 26),
              filled: true,
              fillColor: Colors.white.withOpacity(0.75),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: borderColor.withOpacity(0.30),
                  width: 1.4,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFF30D5A0),
                  width: 2.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
