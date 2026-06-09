class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String upiId;
  final DateTime createdAt;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.upiId,
    required this.createdAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiId': upiId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
      ifscCode: json['ifscCode'] as String,
      upiId: json['upiId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Create a copy with modifications
  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? upiId,
    DateTime? createdAt,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccount &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
