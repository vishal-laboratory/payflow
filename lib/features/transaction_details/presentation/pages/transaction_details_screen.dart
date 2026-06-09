import 'package:flutter/material.dart';
import '../theme/transaction_theme.dart';
import '../widgets/amount_header.dart';
import '../widgets/status_row.dart';
import '../widgets/transaction_details_card.dart';
import '../widgets/help_button.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TransactionTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
          ), // Based on left: 22
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Amount Header
              const AmountHeader(
                amount: '1000',
                receiverName: 'To Mom',
                receiverAvatarUrl: "https://placehold.co/54x54",
              ),
              const SizedBox(
                height: 38,
              ), // Space between amount and status (approx)
              // Status
              const StatusRow(
                timestamp: '17 Nov 2025, 6:26 pm',
                isSuccess: true,
              ),
              const SizedBox(height: 52), // Space to Card
              // Details Card
              const TransactionDetailsCard(
                upiTxnId: '114287233868',
                toName: 'SBI Bank ••••3212',
                toVpa: 'alexmercer@okicici',
                fromName: 'ICICI Bank ••••2090',
                fromVpa: 'alexmercer@okicici',
                googleTxnId: 'CICAgUihmcn3Dg',
                bankLast4: '2020',
              ),

              const SizedBox(height: 30),

              // Disclaimer
              Text(
                'Payments may take up to 3 working days to be reflected\nin your account',
                textAlign: TextAlign.center,
                style: TransactionTheme.bodySmall,
              ),

              const SizedBox(height: 30),

              // Help Button
              const HelpButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
