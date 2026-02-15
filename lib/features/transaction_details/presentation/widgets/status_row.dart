import 'package:flutter/material.dart';
import '../theme/transaction_theme.dart';

class StatusRow extends StatelessWidget {
  final String timestamp;
  final bool isSuccess;

  const StatusRow({super.key, required this.timestamp, this.isSuccess = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status with Checkmark
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSuccess) ...[
              // Custom small filled checkmark circle if needed,
              // or just a clean Icon. Figma code has a 16x16 container.
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: TransactionTheme
                      .contentPrimary, // Using black per code snippet?
                  // Wait, usually it's green. But snippet text color is black.
                  // I will use Green for the icon to be "Success" like.
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 6),
            ],
            Text('Completed', style: TransactionTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        // Timestamp
        Text(
          timestamp,
          style: TransactionTheme
              .bodyMedium, // Actually reuse same style or slightly different?
          // Snippet says: Roboto 14, w500, #1F1F1F. Same as "Completed".
        ),
      ],
    );
  }
}
