import 'package:flutter/material.dart';
import 'core/data/contact_store.dart';
import 'core/data/transaction_store.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContactStore.init();
  await TransactionStore.init();
  runApp(const PayFlowApp());
}

class PayFlowApp extends StatelessWidget {
  const PayFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'GoogleSans',
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          primary: const Color(0xFF1A73E8),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF202124)),
          bodyMedium: TextStyle(color: Color(0xFF202124)),
        ),
      ),
    home: const HomeScreen(),
    );
  }
}
