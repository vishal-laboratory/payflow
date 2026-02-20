import 'dart:ui';
import '../theme/app_colors.dart';

class Contact {
  final String name;
  final List<Color> gradient;
  final String? upiId;

  const Contact({required this.name, required this.gradient, this.upiId});
}

class Transaction {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;
  final bool isPending;

  const Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    this.isPending = false,
  });
}

class MockData {
  static const List<Contact> contacts = [
      Contact(name: 'Vishal', gradient: AppColors.gradientMom),
    // Contact(name: 'Md Tanweer Alam', gradient: AppColors.gradientDad),
    // Contact(name: 'Prince Yadav', gradient: AppColors.gradientRahul),
    // Contact(name: 'Priya', gradient: [Color(0xFFFF9800), Color(0xFFFFC107)]),
    // Contact(name: 'ISHANT', gradient: [Color(0xFF9C27B0), Color(0xFF673AB7)]),
  ];

  static const List<Transaction> transactions = [
    Transaction(
      title: 'To Mom',
      date: 'Today, 6:26 pm',
      amount: 1000.00,
      isCredit: false,
    ),
    Transaction(
      title: 'From Rahul',
      date: 'Yesterday, 2:15 pm',
      amount: 500.00,
      isCredit: true,
    ),
    Transaction(
      title: 'Airtel Recharge',
      date: '15 Nov, 10:30 am',
      amount: 349.00,
      isCredit: false,
    ),
    Transaction(
      title: 'Electricity Bill',
      date: '14 Nov, 9:00 am',
      amount: 2150.00,
      isCredit: false,
    ),
  ];
}
