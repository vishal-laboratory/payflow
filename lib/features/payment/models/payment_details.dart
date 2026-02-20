import 'package:flutter/material.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/data/mock_payment_config.dart';
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

    required this.upiTxnId,
    required this.toName,
    required this.toVpa,
    required this.fromName,
    required this.fromVpa,
    required this.googleTxnId,
  });

  Map<String, dynamic> toSnapshot() {
    return {
      'payeeName': payeeName,
      'payeeInitial': payeeInitial,
      'payeeColor': payeeColor.value,
      'payeeImageUrl': payeeImageUrl,
      'amountText': amountText,
      'currencySymbol': currencySymbol,
      'statusText': statusText,
      'dateTimeText': dateTimeText,
      'bankName': bankName,
      'bankLast4': bankLast4,
      'bankLogoLabel': bankLogoLabel,
      'bankLogoColor': bankLogoColor.value,

      'upiTxnId': upiTxnId,
      'toName': toName,
      'toVpa': toVpa,
      'fromName': fromName,
      'fromVpa': fromVpa,
      'googleTxnId': googleTxnId,
    };
  }

  factory PaymentDetails.fromSnapshot(Map<String, dynamic> map) {
    String readString(String key, [String fallback = '']) {
      final value = map[key];
      if (value is String) {
        return value;
      }
      return fallback;
    }

    int readInt(String key, int fallback) {
      final value = map[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      return fallback;
    }

    return PaymentDetails(
      payeeName: readString('payeeName', 'Receiver'),
      payeeInitial: readString('payeeInitial', 'R'),
      payeeColor: Color(readInt('payeeColor', AppColors.primary.value)),
      payeeImageUrl: map['payeeImageUrl'] as String?,
      amountText: readString('amountText', '0'),
      currencySymbol: readString('currencySymbol', '₹'),
      statusText: readString('statusText', 'Completed'),
      dateTimeText: readString('dateTimeText', ''),
      bankName: readString('bankName', 'Bank'),
      bankLast4: readString('bankLast4', '0000'),
      bankLogoLabel: readString('bankLogoLabel', 'Bank'),
      bankLogoColor: Color(readInt('bankLogoColor', const Color(0xFFB71C1C).value)),

      upiTxnId: readString('upiTxnId', ''),
      toName: readString('toName', ''),
      toVpa: readString('toVpa', ''),
      fromName: readString('fromName', ''),
      fromVpa: readString('fromVpa', ''),
      googleTxnId: readString('googleTxnId', ''),
    );
  }

  factory PaymentDetails.fromContact(Contact contact, String amount, {String? bankName, String? bankLast4}) {
    final bool isQrFlow = contact.upiId != null && contact.upiId!.trim().isNotEmpty;
    final String configuredReceiverName = MockPaymentConfig.receiverName;
    final String displayPayeeName = isQrFlow
        ? contact.name
        : (configuredReceiverName.isNotEmpty ? configuredReceiverName : contact.name);
    final String initial =
      displayPayeeName.isNotEmpty ? displayPayeeName[0].toUpperCase() : '?';

    // Use provided bank details or fall back to MockPaymentConfig
    final String finalBankName = bankName ?? MockPaymentConfig.bankName;
    final String finalBankLast4 = bankLast4 ?? MockPaymentConfig.bankLast4;

    const String figmaPayeeImageUrl =
        'https://www.figma.com/api/mcp/asset/63938c2b-df69-438d-8254-6105c8621841';
    return PaymentDetails(
      payeeName: displayPayeeName,
      payeeInitial: initial,
      payeeColor:
          contact.gradient.isNotEmpty ? contact.gradient.first : AppColors.primary,
      payeeImageUrl: displayPayeeName == 'Mom' ? figmaPayeeImageUrl : null,
      amountText: amount,
      dateTimeText: MockPaymentConfig.formattedTransactionDateTime(),
      bankName: finalBankName,
      bankLast4: finalBankLast4,
      bankLogoLabel: finalBankName,
      bankLogoColor: const Color(0xFFB71C1C),

      upiTxnId: MockPaymentConfig.generateUpiRRN(),
      toName: isQrFlow ? contact.name : MockPaymentConfig.toReceiverName,
      toVpa: isQrFlow ? contact.upiId! : MockPaymentConfig.toReceiverUpiId,
      fromName: MockPaymentConfig.fromPayerName,
      fromVpa: MockPaymentConfig.fromPayerUpiId,
      googleTxnId: MockPaymentConfig.generateGoogleTransactionId(),
    );
  }
}
