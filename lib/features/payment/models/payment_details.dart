import 'package:flutter/material.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_colors.dart';

class PaymentDetails {
  final String payeeName;
  final String payeeInitial;
  final Color payeeColor;
  final String amountText;
  final String currencySymbol;
  final String statusText;
  final String dateTimeText;
  final String bankName;
  final String bankLast4;
  final String bankLogoLabel;
  final Color bankLogoColor;
  final String upiTxnId;
  final String toName;
  final String toVpa;
  final String fromName;
  final String fromVpa;
  final String googleTxnId;

  const PaymentDetails({
    required this.payeeName,
    required this.payeeInitial,
    required this.payeeColor,
    required this.amountText,
    this.currencySymbol = '₹',
    this.statusText = 'Completed',
    this.dateTimeText = '4 Feb 2026, 4:49 pm',
    required this.bankName,
    required this.bankLast4,
    required this.bankLogoLabel,
    required this.bankLogoColor,
    required this.upiTxnId,
    required this.toName,
    required this.toVpa,
    required this.fromName,
    required this.fromVpa,
    required this.googleTxnId,
  });

  factory PaymentDetails.fromContact(Contact contact, String amount) {
    final String initial =
        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';

    return PaymentDetails(
      payeeName: contact.name,
      payeeInitial: initial,
      payeeColor:
          contact.gradient.isNotEmpty ? contact.gradient.first : AppColors.primary,
      amountText: amount,
      bankName: 'Central Bank of India',
      bankLast4: '4547',
      bankLogoLabel: 'CBI',
      bankLogoColor: const Color(0xFFC62828),
      upiTxnId: '640126569989',
      toName: contact.name,
      toVpa: 'paytm-51955531@ptys',
      fromName: 'Mr VISHAL CHAUDHARY (Central Bank of India)',
      fromVpa: 'hardichboy@okicici',
      googleTxnId: 'CICAgJjyle_NMg',
    );
  }
}
