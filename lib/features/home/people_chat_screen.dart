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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contact.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Online now',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(LucideIcons.phone,
                color: AppColors.googleBlue, size: 20),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(LucideIcons.moreVertical,
                color: AppColors.textPrimary, size: 20),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.send,
                          size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start by sending money to this contact',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  itemCount: records.length + (records.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Add date header at the beginning
                    if (index == 0 && records.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary.withOpacity(0.6),
                          ),
                        ),
                      );
                    }

                    final recordIndex = index - 1;
                    final record = records[recordIndex];
                    final isOutgoing = record.receiverName == contact.name;

                    return GestureDetector(
                      onTap: record.paymentSnapshot == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PaymentSuccessScreen(
                                    details: PaymentDetails
                                        .fromSnapshot(
                                      record.paymentSnapshot!,
                                    ),
                                  ),
                                ),
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    isOutgoing
                                        ? 'Sent to ${contact.name}'
                                        : 'Received from ${contact.name}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w500,
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                  ),
                                  if (!isOutgoing)
                                    Icon(
                                      LucideIcons.chevronRight,
                                      size: 18,
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${record.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Color(0xFF1E8E3E),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Paid • ${_formatDate(record.createdAt)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors
                                          .textSecondary,
                                      fontWeight:
                                          FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    LucideIcons.chevronRight,
                                    size: 16,
                                    color: AppColors
                                        .textSecondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              Positioned(
                right: 16,
                bottom: 16,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SendMoneyScreen(contact: contact),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.googleBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.send, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}';
  }
}