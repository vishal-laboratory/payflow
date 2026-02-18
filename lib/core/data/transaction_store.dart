import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactTransactionRecord {
  final String receiverName;
  final double amount;
  final DateTime createdAt;
  final Map<String, dynamic>? paymentSnapshot;

  const ContactTransactionRecord({
    required this.receiverName,
    required this.amount,
    required this.createdAt,
    this.paymentSnapshot,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiverName': receiverName,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'paymentSnapshot': paymentSnapshot,
    };
  }

  factory ContactTransactionRecord.fromJson(Map<String, dynamic> json) {
    return ContactTransactionRecord(
      receiverName: (json['receiverName'] as String?) ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
        paymentSnapshot: json['paymentSnapshot'] is Map
          ? (json['paymentSnapshot'] as Map)
            .map((key, value) => MapEntry(key.toString(), value))
          : null,
    );
  }
}

class TransactionStore {
  static const String _storageKey = 'payflow_transactions_v1';
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);
  static final List<ContactTransactionRecord> _records = [];

  static List<ContactTransactionRecord> get allRecords =>
      List<ContactTransactionRecord>.unmodifiable(_records);

  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_storageKey);

    _records
      ..clear()
      ..addAll(_decode(raw));
    changes.value = changes.value + 1;
  }

  static List<ContactTransactionRecord> recordsForContact(String name) {
    final normalizedName = name.trim().toLowerCase();
    return _records
        .where(
          (record) => record.receiverName.trim().toLowerCase() == normalizedName,
        )
        .toList(growable: false);
  }

  static void addPayment({
    required String receiverName,
    required double amount,
    DateTime? createdAt,
    Map<String, dynamic>? paymentSnapshot,
  }) async {
    _records.insert(
      0,
      ContactTransactionRecord(
        receiverName: receiverName.trim(),
        amount: amount,
        createdAt: createdAt ?? DateTime.now(),
        paymentSnapshot: paymentSnapshot,
      ),
    );
    await _save();
    changes.value = changes.value + 1;
  }

  static Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      _records.map((record) => record.toJson()).toList(growable: false),
    );
    await preferences.setString(_storageKey, payload);
  }

  static List<ContactTransactionRecord> _decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }
      return decoded
          .whereType<Map>()
          .map(
            (item) => ContactTransactionRecord.fromJson(
              item.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            ),
          )
          .toList(growable: true);
    } catch (_) {
      return [];
    }
  }

  static String formatForHistory(DateTime dateTime) {
    final now = DateTime.now();
    final isSameDate = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
    if (isSameDate) {
      return 'Today, ${_time(dateTime)}';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == dateTime.year &&
        yesterday.month == dateTime.month &&
        yesterday.day == dateTime.day;
    if (isYesterday) {
      return 'Yesterday, ${_time(dateTime)}';
    }

    return '${dateTime.day} ${_month(dateTime.month)}, ${_time(dateTime)}';
  }

  static String formatForChat(DateTime dateTime) {
    return '${dateTime.day} ${_month(dateTime.month)}, ${_time(dateTime)}';
  }

  static String _time(DateTime dateTime) {
    final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final meridiem = dateTime.hour >= 12 ? 'pm' : 'am';
    return '$hour12:$minute $meridiem';
  }

  static String _month(int month) {
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
    return months[month - 1];
  }
}