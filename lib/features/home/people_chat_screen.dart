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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    contact.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Active now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.phone,
                color: AppColors.textPrimary, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.video,
                color: AppColors.textPrimary, size: 20),
          ),
          IconButton(
            onPressed: () {},
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
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 120),
                  itemCount: records.length + (records.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Add date header at the beginning
                    if (index == 0 && records.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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

                    final recordIndex =
                        index - 1; // Adjust for date header
                    final record = records[recordIndex];
                    final isOutgoing =
                        record.receiverName == contact.name;

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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  contact.gradient.first,
                              child: Text(
                                contact.name.isNotEmpty
                                    ? contact.name[0]
                                        .toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Transaction Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isOutgoing
                                                  ? 'Sent to ${contact.name}'
                                                  : 'Received from ${contact.name}',
                                              style:
                                                  const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                                color: AppColors
                                                    .textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                            ),
                                            const SizedBox(
                                                height: 4),
                                            Text(
                                              TransactionStore
                                                  .formatForChat(
                                                      record
                                                          .createdAt),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors
                                                    .textSecondary
                                                    .withOpacity(
                                                        0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Amount Section
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                        children: [
                                          Text(
                                            isOutgoing
                                                ? '-₹${record.amount.toStringAsFixed(2)}'
                                                : '+₹${record.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: isOutgoing
                                                  ? AppColors
                                                      .textPrimary
                                                  : const Color(
                                                      0xFF34A853),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                            decoration:
                                                BoxDecoration(
                                              color: AppColors
                                                  .success
                                                  .withOpacity(
                                                      0.15),
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          4),
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .check_circle,
                                                  color: AppColors
                                                      .success,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                    width: 4),
                                                Text(
                                                  'Paid',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors
                                                        .success,
                                                    fontWeight:
                                                        FontWeight
                                                            .w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Notes/Reference
                                  Container(
                                    padding:
                                        const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius:
                                          BorderRadius.circular(
                                              8),
                                      border: Border.all(
                                        color: AppColors
                                            .borderLight,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          LucideIcons.info,
                                          size: 14,
                                          color: AppColors
                                              .textSecondary
                                              .withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Transaction ID: ${_getTxnIdPreview(record.paymentSnapshot)}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors
                                                  .textSecondary
                                                  .withOpacity(
                                                      0.6),
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                          builder: (_) =>
                              SendMoneyScreen(contact: contact),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.googleBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 34),
                      elevation: 4,
                      shadowColor: AppColors.googleBlue
                          .withOpacity(0.4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.send,
                            size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Pay',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
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

  String _getTxnIdPreview(Map<String, dynamic>? snapshot) {
    if (snapshot == null) return 'N/A';
    final txnId = snapshot['transactionId']?.toString() ?? 'N/A';
    return txnId.length > 8 ? '${txnId.substring(0, 8)}...' : txnId;
  }
}