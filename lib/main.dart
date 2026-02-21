import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/data/contact_store.dart';
import 'core/data/transaction_store.dart';
import 'core/data/bank_account_store.dart';
import 'core/data/mock_payment_config.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContactStore.init();
  await TransactionStore.init();
  await BankAccountStore.initialize();
  await MockPaymentConfig.loadUserProfile();
  runApp(const PayFlowApp());
}

class PayFlowApp extends StatefulWidget {
  const PayFlowApp({super.key});

  @override
  State<PayFlowApp> createState() => _PayFlowAppState();
}

class _PayFlowAppState extends State<PayFlowApp> {
  bool _isFirstLaunch = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    if (isFirstLaunch) {
      // Mark as not first launch
      await prefs.setBool('isFirstLaunch', false);
    }
    
    setState(() {
      _isFirstLaunch = isFirstLaunch;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'GoogleSans',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
         //
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          primary: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF202124)),
          bodyMedium: TextStyle(color: Color(0xFF202124)),
        ),
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SplashScreen(
              nextScreen: _isFirstLaunch
                  ? const FirstLaunchScreen()
                  : const HomeScreen(),
            ),
    );
  }
}

class FirstLaunchScreen extends StatefulWidget {
  const FirstLaunchScreen({super.key});

  @override
  State<FirstLaunchScreen> createState() => _FirstLaunchScreenState();
}

class _FirstLaunchScreenState extends State<FirstLaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Show snackbar and navigate to profile after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.info, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Welcome! Please fill in your profile details to get started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.googleBlue,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate to profile screen
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ProfileScreenFirstTime(),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ProfileScreenFirstTime extends StatelessWidget {
  const ProfileScreenFirstTime({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(isFirstLaunch: true);
  }
}
