/// Demo file showing how to use the transaction ID generation functions
/// Delete this file after testing

import 'core/data/mock_payment_config.dart';

void main() {
  print('🔹 UPI RRN Generation Examples:');
  print('');

  // Generate 5 different RRNs to show variability
  for (int i = 1; i <= 5; i++) {
    final rrn = MockPaymentConfig.generateUpiRRN();
    print('RRN #$i: $rrn (12 digits)');
  }

  print('');
  print('✓ Each UPI RRN has:');
  print('  - Last 7 digits of epoch milliseconds (time-influenced)');
  print('  - 5 digit cryptographic random number');
  print('  - Total: 12 numeric digits only');

  print('');
  print('═════════════════════════════════════════');
  print('');
  print('🔹 Google Transaction ID Generation Examples:');
  print('');

  // Generate 5 different Google IDs to show variability
  for (int i = 1; i <= 5; i++) {
    final googleId = MockPaymentConfig.generateGoogleTransactionId();
    print('Google TXN #$i: $googleId (${googleId.length} chars)');
  }

  print('');
  print('✓ Each Google ID has:');
  print('  - Prefix: "CICAg" (standard Google format)');
  print('  - Base64 URL-safe encoding');
  print('  - Length: 14-18 characters');
  print('  - Contains alphanumeric + underscore characters');
}

/// Integration examples:
/// 
/// 1. In EditMockPaymentDetailsScreen:
///    _upiTxnIdController.text = MockPaymentConfig.generateUpiRRN();
///    _googleTxnIdController.text = MockPaymentConfig.generateGoogleTransactionId();
/// 
/// 2. Auto-generate on payment creation:
///    MockPaymentConfig.update(
///      upiTransactionId: MockPaymentConfig.generateUpiRRN(),
///      googleTransactionId: MockPaymentConfig.generateGoogleTransactionId(),
///      ...other fields...
///    );
/// 
/// 3. In PaymentDetails.fromContact():
///    upiTxnId: MockPaymentConfig.generateUpiRRN(),
///    googleTxnId: MockPaymentConfig.generateGoogleTransactionId(),

