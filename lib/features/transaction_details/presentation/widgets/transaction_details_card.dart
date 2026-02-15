import 'package:flutter/material.dart';
import '../theme/transaction_theme.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String upiTxnId;
  final String toName;
  final String toVpa;
  final String fromName;
  final String fromVpa;
  final String googleTxnId;
  final String bankLast4;

  const TransactionDetailsCard({
    super.key,
    required this.upiTxnId,
    required this.toName,
    required this.toVpa,
    required this.fromName,
    required this.fromVpa,
    required this.googleTxnId,
    required this.bankLast4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 349,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TransactionTheme.borderLight, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Bank Info (Top 60px roughly)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TransactionTheme.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Bank Logo Placeholder
                    Container(
                      width: 46,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: TransactionTheme.borderLight),
                        borderRadius: BorderRadius.circular(4),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://placehold.co/46x28",
                          ), // Placeholder
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'ICICI Bank ••••$bankLast4',
                      // Roboto 16, w400, letterSpacing 1
                      style: TransactionTheme.receiverNameStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                // Arrow Down
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: TransactionTheme.contentPrimary,
                ),
              ],
            ),
          ),

          // Content Padding
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('UPI transaction ID', upiTxnId),
                const SizedBox(height: 16), // Gap 16 roughly
                _buildRichRow('To: $toName', toVpa),
                const SizedBox(height: 16),
                _buildRichRow('From: $fromName', fromVpa),
                const SizedBox(height: 16),
                _buildDetailRow('Google transaction ID', googleTxnId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TransactionTheme.detailUseLabel),
        const SizedBox(height: 4),
        Text(value, style: TransactionTheme.detailValue),
      ],
    );
  }

  Widget _buildRichRow(String label, String vpa) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TransactionTheme.detailUseLabel),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Google Pay ',
                style: TransactionTheme.labelSmallRegular.copyWith(
                  height: 1.17,
                ),
              ),
              TextSpan(
                text: '• ',
                style: TransactionTheme.labelSmallBold.copyWith(height: 1.17),
              ),
              TextSpan(
                text: vpa,
                style:
                    TransactionTheme.detailValue, // Regular weight, no spacing
              ),
            ],
          ),
        ),
      ],
    );
  }
}
