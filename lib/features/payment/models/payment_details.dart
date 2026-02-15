import 'package:flutter/material.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/theme/app_colors.dart';

class PaymentDetails {
  final String payeeName;
  final String payeeInitial;
  final Color payeeColor;
  final String? payeeImageUrl;
  final String amountText;
  final String currencySymbol;
  final String statusText;
  final String dateTimeText;
  final String bankName;
  final String bankLast4;
  final String bankLogoLabel;
  final Color bankLogoColor;
  final String? bankLogoUrl;
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
    this.payeeImageUrl,
    required this.amountText,
    this.currencySymbol = '₹',
    this.statusText = 'Completed',
    this.dateTimeText = '4 Feb 2026, 4:49 pm',
    required this.bankName,
    required this.bankLast4,
    required this.bankLogoLabel,
    required this.bankLogoColor,
    this.bankLogoUrl,
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

    const String figmaPayeeImageUrl =
        'https://www.figma.com/api/mcp/asset/63938c2b-df69-438d-8254-6105c8621841';
    const String figmaBankLogoUrl =
        'https://www.figma.com/api/mcp/asset/066094ac-04ed-4b14-ae42-89fdc6a13237';

    return PaymentDetails(
      payeeName: contact.name,
      payeeInitial: initial,
      payeeColor:
          contact.gradient.isNotEmpty ? contact.gradient.first : AppColors.primary,
      payeeImageUrl: contact.name == 'Mom' ? figmaPayeeImageUrl : null,
      amountText: amount,
      dateTimeText: '17 Nov 2025, 6:26 pm',
      bankName: 'ICICI Bank',
      bankLast4: '2020',
      bankLogoLabel: 'ICICI',
      bankLogoColor: const Color(0xFFB71C1C),
      bankLogoUrl: figmaBankLogoUrl,
      upiTxnId: '114287233868',
      toName: 'SBI Bank ••••3212',
      toVpa: 'alexmercer@okicici',
      fromName: 'ICICI Bank ••••2090',
      fromVpa: 'alexmercer@okicici',
      googleTxnId: 'CICAgUihmcn3Dg',
    );
  }
}
