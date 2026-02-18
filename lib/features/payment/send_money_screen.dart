import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/numpad.dart';
import '../../core/data/transaction_store.dart';
import 'payment_success_screen.dart';
import 'models/payment_details.dart';
import '../../core/data/mock_data.dart';

class SendMoneyScreen extends StatefulWidget {
  final Contact contact;

  const SendMoneyScreen({super.key, required this.contact});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String amount = '0';
  bool isLoading = false;

  void _onKeyPressed(String value) {
    setState(() {
      if (amount == '0') {
        amount = value;
      } else if (amount.length < 7) {
        // Limit max amount
        amount += value;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = '0';
      }
    });
  }

  void _onClear() {
    setState(() {
      amount = '0';
    });
  }

  void _processPayment() async {
    if (amount == '0') return;

    setState(() => isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final details = PaymentDetails.fromContact(widget.contact, amount);
    final paidAmount = double.tryParse(amount) ?? 0;
    TransactionStore.addPayment(
      receiverName: widget.contact.name,
      amount: paidAmount,
      paymentSnapshot: details.toSnapshot(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(details: details),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(color: AppColors.textPrimary),
        title: const Text('Send Money'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Recipient Info
          Hero(
            tag: 'avatar_${widget.contact.name}',
            child: Avatar(
              label: widget.contact.name,
              gradient: widget.contact.gradient,
              size: 64,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To ${widget.contact.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (widget.contact.upiId != null && widget.contact.upiId!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.contact.upiId!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          amount,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter amount',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          // Pay Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.googleBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay ₹$amount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Keypad
          Numpad(
            onKeyPressed: _onKeyPressed,
            onDelete: _onDelete,
            onClear: _onClear,
          ),
        ],
      ),
    );
  }
}
