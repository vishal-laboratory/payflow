import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedOperator;

  final List<Map<String, dynamic>> _operators = [
    {'name': 'Jio Prepaid', 'color': Color(0xFF0F3A96)},
    {'name': 'Airtel Prepaid', 'color': Color(0xFFE40000)}, // Red
    {'name': 'Vi Prepaid', 'color': Color(0xFFFFC600)}, // Yellow
    {'name': 'BSNL', 'color': Color(0xFF008000)},
  ];

  void _showOperatorPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Operator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._operators.map(
                (op) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (op['color'] as Color).withOpacity(0.1),
                    child: Text(
                      (op['name'] as String)[0],
                      style: TextStyle(
                        color: op['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(op['name']),
                  onTap: () {
                    setState(() => _selectedOperator = op['name']);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(color: AppColors.textPrimary),
        title: const Text('Mobile Recharge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recharge Smarter',
                          style: TextStyle(
                            color: AppColors.googleBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Get 10% cashback on your first recharge',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.zap, color: Colors.amber, size: 40),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Input
            const Text(
              'Enter mobile number',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '00000 00000',
              ),
            ),

            const SizedBox(height: 24),

            // Operator Selector
            InkWell(
              onTap: _showOperatorPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedOperator ?? 'Select Operator',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedOperator == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feature coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors
                      .textPrimary, // Disabled looking style if invalid, but active for prototype
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
