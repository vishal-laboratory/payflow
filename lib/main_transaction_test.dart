import 'package:flutter/material.dart';
import 'package:payflow/features/transaction_details/presentation/pages/transaction_details_screen.dart';
import 'package:payflow/core/theme/app_theme.dart';

void main() {
  runApp(const TransactionTestApp());
}

class TransactionTestApp extends StatelessWidget {
  const TransactionTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction Details Test',
      theme: AppTheme.lightTheme,
      home: const TransactionDetailsScreen(),
    );
  }
}
