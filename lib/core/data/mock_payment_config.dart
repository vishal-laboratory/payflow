class BankOption {
  final String name;
  final String logoAssetPath;

  const BankOption({required this.name, required this.logoAssetPath});
}

class MockPaymentConfig {
  static const String _defaultReceiverName = 'Reciver name';
  static const String _defaultBankName = 'Central Bank of India';
  static const String _defaultBankLogoPath = 'assets/bank/cbi-bank.png';
  static const String _defaultBankLast4 = '4547';
  static const String _defaultUpiTxnId = '640951684878';
  static const String _defaultToReceiverName = ' ReceiverName';
  static const String _defaultToReceiverUpiId = 'sonu029@ibl';
  static const String _defaultFromPayerName = ' Sender Name';
  static const String _defaultFromPayerUpiId = 'alexmercer@okicici';
  static const String _defaultGoogleTxnId = 'CICAgUihmcn3Dg';
  static final DateTime _defaultTransactionDateTime = DateTime(2026, 2, 18, 1, 55);

  static String receiverName = _defaultReceiverName;
  static String bankName = _defaultBankName;
  static String bankLogoPath = _defaultBankLogoPath;
  static String bankLast4 = _defaultBankLast4;
  static String upiTransactionId = _defaultUpiTxnId;
  static String toReceiverName = _defaultToReceiverName;
  static String toReceiverUpiId = _defaultToReceiverUpiId;
  static String fromPayerName = _defaultFromPayerName;
  static String fromPayerUpiId = _defaultFromPayerUpiId;
  static String googleTransactionId = _defaultGoogleTxnId;
  static DateTime transactionDateTime = _defaultTransactionDateTime;

  static const List<BankOption> bankOptions = [
    BankOption(name: 'State Bank of India', logoAssetPath: 'assets/bank/sbi-bank.png'),
    BankOption(name: 'HDFC Bank', logoAssetPath: 'assets/bank/hdfc-bank.png'),
    BankOption(name: 'Axis Bank', logoAssetPath: 'assets/bank/axis-bank.png'),
    BankOption(name: 'ICICI Bank', logoAssetPath: 'assets/bank/icici-bank.png'),
    BankOption(name: 'Bank of Baroda', logoAssetPath: 'assets/bank/img.png'),
    BankOption(name: 'Canara Bank', logoAssetPath: 'assets/bank/canara-bank.png'),
    BankOption(
      name: 'Central Bank of India',
      logoAssetPath: 'assets/bank/cbi-bank.png',
    ),
  ];

  static void update({
    required String receiverName,
    required String bankName,
    required String bankLast4,
    required String upiTransactionId,
    required String toReceiverName,
    required String toReceiverUpiId,
    required String fromPayerName,
    required String fromPayerUpiId,
    required String googleTransactionId,
    required DateTime transactionDateTime,
  }) {
    MockPaymentConfig.receiverName = _normalize(
      receiverName,
      _defaultReceiverName,
    );
    MockPaymentConfig.bankName = _normalize(bankName, _defaultBankName);
    MockPaymentConfig.bankLogoPath = logoForBankName(MockPaymentConfig.bankName);
    MockPaymentConfig.bankLast4 = _normalize(bankLast4, _defaultBankLast4);
    MockPaymentConfig.upiTransactionId = _normalize(
      upiTransactionId,
      _defaultUpiTxnId,
    );
    MockPaymentConfig.toReceiverName = _normalize(
      toReceiverName,
      _defaultToReceiverName,
    );
    MockPaymentConfig.toReceiverUpiId = _normalize(
      toReceiverUpiId,
      _defaultToReceiverUpiId,
    );
    MockPaymentConfig.fromPayerName = _normalize(
      fromPayerName,
      _defaultFromPayerName,
    );
    MockPaymentConfig.fromPayerUpiId = _normalize(
      fromPayerUpiId,
      _defaultFromPayerUpiId,
    );
    MockPaymentConfig.googleTransactionId = _normalize(
      googleTransactionId,
      _defaultGoogleTxnId,
    );
    MockPaymentConfig.transactionDateTime = transactionDateTime;
  }

  static String _normalize(String value, String fallback) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String logoForBankName(String bankName) {
    final normalizedInput = bankName.trim().toLowerCase();

    for (final option in bankOptions) {
      if (option.name.toLowerCase() == normalizedInput) {
        return option.logoAssetPath;
      }
    }

    if (normalizedInput.contains('sbi') || normalizedInput.contains('state bank')) {
      return 'assets/bank/sbi-bank.png';
    }
    if (normalizedInput.contains('hdfc')) {
      return 'assets/bank/hdfc-bank.png';
    }
    if (normalizedInput.contains('axis')) {
      return 'assets/bank/axis-bank.png';
    }
    if (normalizedInput.contains('icici')) {
      return 'assets/bank/icici-bank.png';
    }
    if (normalizedInput.contains('baroda') || normalizedInput.contains('bob')) {
      return 'assets/bank/img.png';
    }
    if (normalizedInput.contains('canara')) {
      return 'assets/bank/canara-bank.png';
    }
    if (normalizedInput.contains('central')) {
      return 'assets/bank/cbi-bank.png';
    }

    return _defaultBankLogoPath;
  }

  static String formattedTransactionDateTime() {
    final dt = transactionDateTime;
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

    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final meridiem = dt.hour >= 12 ? 'pm' : 'am';

    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour12:$minute $meridiem';
  }
}