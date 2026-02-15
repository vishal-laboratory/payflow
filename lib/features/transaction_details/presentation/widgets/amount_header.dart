import 'package:flutter/material.dart';
import '../theme/transaction_theme.dart';

class AmountHeader extends StatelessWidget {
  final String amount;
  final String receiverName;
  final String? receiverAvatarUrl;

  const AmountHeader({
    super.key,
    required this.amount,
    required this.receiverName,
    this.receiverAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF464646), width: 1),
            image: receiverAvatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(receiverAvatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: Colors.grey[200], // Fallback
          ),
          child: receiverAvatarUrl == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 8), // Gap 8px? Visual approx.
        // Name
        Text(receiverName, style: TransactionTheme.receiverNameStyle),
        const SizedBox(height: 20), // Visual spacing to amount
        // Amount Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('₹', style: TransactionTheme.currencySymbolStyle),
            const SizedBox(width: 4),
            Text(amount, style: TransactionTheme.amountStyle),
          ],
        ),
      ],
    );
  }
}
