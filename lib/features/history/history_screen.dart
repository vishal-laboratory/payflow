import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../transaction_details/presentation/pages/transaction_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: BackButton(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.transactions.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final transaction = MockData.transactions[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionDetailsScreen(),
                ),
              );
            },
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF3F6FC),
              child: Icon(
                transaction.isCredit
                    ? LucideIcons.arrowDownLeft
                    : LucideIcons.arrowUpRight,
                color: transaction.isCredit
                    ? AppColors.success
                    : AppColors.textPrimary,
                size: 20,
              ),
            ),
            title: Text(
              transaction.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(transaction.date),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transaction.isCredit
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                if (transaction.isPending)
                  const Text(
                    'Processing',
                    style: TextStyle(fontSize: 12, color: AppColors.googleBlue),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
