import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String label;
  final List<Color>? gradient;
  final Color? color;
  final double size;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    required this.label,
    this.gradient,
    this.color,
    this.size = 48,
    this.onTap,
  }) : assert(gradient != null || color != null);

  @override
  Widget build(BuildContext context) {
    final avatarColor = color ?? gradient!.first;
    final avatarGradient = gradient ?? [avatarColor, avatarColor];

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: avatarGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: avatarColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}
