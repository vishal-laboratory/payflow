import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/mock_data.dart';
import '../../core/data/transaction_store.dart';
import '../../core/theme/app_colors.dart';
import '../payment/models/payment_details.dart';
import '../payment/payment_success_screen.dart';
import '../payment/send_money_screen.dart';

class PeopleChatScreen extends StatelessWidget {
  final Contact contact;

  const PeopleChatScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: BackButton(color: AppColors.textPrimary),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: contact.gradient.first,
              child: Text(
                contact.name.isNotEmpty
                    ? contact.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                contact.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.moreVertical, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: TransactionStore.changes,
        builder: (context, _, __) {
          final records = TransactionStore.recordsForContact(contact.name);

          return Stack(
            children: [
              if (records.isEmpty)
                const Center(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return GestureDetector(
                      onTap: record.paymentSnapshot == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentSuccessScreen(
                                    details: PaymentDetails.fromSnapshot(
                                      record.paymentSnapshot!,
                                    ),
                                  ),
                                ),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment to ${record.receiverName.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${record.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Paid • ${TransactionStore.formatForChat(record.createdAt)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Positioned(
                right: 16,
                bottom: 16,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SendMoneyScreen(contact: contact),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.googleBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}