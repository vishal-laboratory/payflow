import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bank_account.dart';
import 'mock_payment_config.dart';

class BankAccountStore {
  static const String _storageKey = 'bank_accounts';
  static final ValueNotifier<List<BankAccount>> _accounts =
      ValueNotifier<List<BankAccount>>([]);

  // Expose accounts as a ValueNotifier for reactive updates
  static ValueNotifier<List<BankAccount>> get accountsNotifier => _accounts;

  static List<BankAccount> get allAccounts => _accounts.value;

  // Initialize accounts from storage
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final accounts = jsonList
            .map((item) => BankAccount.fromJson(item as Map<String, dynamic>))
            .toList();
        _accounts.value = accounts;
        MockPaymentConfig.syncPrimaryAccount(accounts);
      } catch (e) {
        debugPrint('Error loading bank accounts: $e');
        _accounts.value = [];
      }
    } else {
      _accounts.value = [];
    }
  }

  // Add a new bank account
  static Future<void> addAccount(BankAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = List<BankAccount>.from(_accounts.value);
    accounts.add(account);
    _accounts.value = accounts;
    MockPaymentConfig.syncPrimaryAccount(accounts);

    // Save to storage
    final jsonString = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  // Remove a bank account
  static Future<void> removeAccount(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = List<BankAccount>.from(_accounts.value);
    accounts.removeWhere((account) => account.id == accountId);
    _accounts.value = accounts;
    MockPaymentConfig.syncPrimaryAccount(accounts);

    // Save to storage
    final jsonString = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  // Update a bank account
  static Future<void> updateAccount(BankAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = List<BankAccount>.from(_accounts.value);
    final index = accounts.indexWhere((a) => a.id == account.id);

    if (index >= 0) {
      accounts[index] = account;
      _accounts.value = accounts;
      MockPaymentConfig.syncPrimaryAccount(accounts);

      // Save to storage
      final jsonString = jsonEncode(accounts.map((a) => a.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    }
  }

  // Get account by ID
  static BankAccount? getAccountById(String accountId) {
    try {
      return _accounts.value.firstWhere((a) => a.id == accountId);
    } catch (e) {
      return null;
    }
  }

  // Clear all accounts
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    _accounts.value = [];
    await prefs.remove(_storageKey);
  }
}
