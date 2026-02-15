import 'package:flutter/material.dart';
import '../theme/transaction_theme.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TransactionTheme.borderDark, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container 16x16
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: const Icon(
              Icons.help_outline,
              size: 14,
              color: TransactionTheme.contentPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text('Having issues?', style: TransactionTheme.bodyMedium),
        ],
      ),
    );
  }
}
