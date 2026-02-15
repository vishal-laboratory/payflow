import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Numpad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  const Numpad({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(
                'C',
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondary,
                ),
                onTap: onClear,
              ),
              _buildButton('0'),
              _buildButton(
                '⌫',
                icon: Icons.backspace_outlined,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) => _buildButton(k)).toList(),
    );
  }

  Widget _buildButton(
    String text, {
    TextStyle? textStyle,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => onKeyPressed(text),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 80,
        height: 60,
        child: Center(
          child: icon != null
              ? Icon(icon, color: AppColors.textPrimary)
              : Text(
                  text,
                  style:
                      textStyle ??
                      const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                ),
        ),
      ),
    );
  }
}
