import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/numpad.dart';
import '../../core/data/transaction_store.dart';
import '../../core/data/bank_account_store.dart';
import '../../core/models/bank_account.dart';
import '../profile/profile_screen.dart';
import 'payment_success_screen.dart';
import 'models/payment_details.dart';
import '../../core/data/mock_data.dart';

class SendMoneyScreen extends StatefulWidget {
  final Contact contact;
  final BankAccount? preSelectedAccount;

  const SendMoneyScreen({
    super.key,
    required this.contact,
    this.preSelectedAccount,
  });

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String amount = '0';
  bool isLoading = false;
  bool _showNumpad = true;
  BankAccount? selectedBankAccount;

  @override
  void initState() {
    super.initState();
    // Use pre-selected account if provided
    selectedBankAccount = widget.preSelectedAccount;
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (amount == '0') {
        amount = value;
      } else if (amount.length < 7) {
        // Limit max amount
        amount += value;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = '0';
      }
    });
  }

  void _onClear() {
    setState(() {
      amount = '0';
    });
  }

  void _toggleNumpadVisibility() {
    setState(() {
      _showNumpad = !_showNumpad;
    });
  }

  void _processPayment() async {
    if (amount == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    if (selectedBankAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank account')),
      );
      return;
    }

    setState(() => isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Extract last 4 digits of account number
    final accountLast4 = selectedBankAccount!.accountNumber.length >= 4
        ? selectedBankAccount!.accountNumber.substring(selectedBankAccount!.accountNumber.length - 4)
        : selectedBankAccount!.accountNumber;

    final details = PaymentDetails.fromContact(
      widget.contact,
      amount,
      bankName: selectedBankAccount!.bankName,
      bankLast4: accountLast4,
    );
    final paidAmount = double.tryParse(amount) ?? 0;
    TransactionStore.addPayment(
      receiverName: widget.contact.name,
      amount: paidAmount,
      paymentSnapshot: details.toSnapshot(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(details: details),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(color: AppColors.textPrimary),
        title: const Text('Send Money'),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Recipient Section
                    _buildRecipientHeader(),
                    const SizedBox(height: 32),
                    // Amount Display with Arrow Button
                    _buildAmountWithArrow(),
                    if (!_showNumpad) ..._buildAmountEditableHint() else const SizedBox(height: 24),
                    // Add Note (Optional)
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Add note',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Bank Account Selector - Hidden when numpad is shown
                    if (!_showNumpad) ...[
                      _buildBankAccountSelectorCard(),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Pay Button - Always visible above numpad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildPayButton(),
          ),
          // Numpad at Bottom - Only shown when needed
          if (_showNumpad) _buildNumpadSheet(),
        ],
      ),
    );
  }

  Widget _buildRecipientHeader() {
    return Column(
      children: [
        Avatar(
          label: widget.contact.name[0].toUpperCase(),
          gradient: widget.contact.gradient,
          size: 72,
        ),
        const SizedBox(height: 16),
        Text(
          'Paying ${widget.contact.name}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 16, color: Color(0xFF1E8E3E)),
            const SizedBox(width: 4),
            Text(
              'Banking name: ${widget.contact.name}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.contact.upiId ?? 'UPI ID',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountWithArrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _toggleNumpadVisibility,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  '₹',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (amount != '0' && selectedBankAccount == null)
          GestureDetector(
            onTap: () {
              setState(() => _showNumpad = false);
              final accounts = BankAccountStore.allAccounts;
              if (accounts.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              } else {
                _showBankSelectionSheet(accounts);
              }
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.googleBlue,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                LucideIcons.arrowRight,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildAmountEditableHint() {
    return [
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: _toggleNumpadVisibility,
          child: Text(
            'Tap amount to edit',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.googleBlue,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildBankAccountSelectorCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Choose account to pay with',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ValueListenableBuilder<List<BankAccount>>(
          valueListenable: BankAccountStore.accountsNotifier,
          builder: (context, accounts, _) {
            if (accounts.isEmpty) {
              return GestureDetector(
                onTap: () {
                  // Haptic feedback
                  HapticFeedback.mediumImpact();
                  
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(LucideIcons.alertCircle, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('No account found. Add a bank account to continue'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF1F2937),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  
                  // Navigate after a brief delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.building2,
                        color: AppColors.googleBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Add bank account',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.googleBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        LucideIcons.chevronRight,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }

            final account = selectedBankAccount ?? accounts.first;
            return GestureDetector(
              onTap: () => _showBankSelectionSheet(accounts),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        LucideIcons.building2,
                        color: AppColors.googleBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.bankName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '****${account.accountNumber.length >= 4 ? account.accountNumber.substring(account.accountNumber.length - 4) : account.accountNumber}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronDown,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading || amount == '0' || selectedBankAccount == null ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: (amount == '0' || selectedBankAccount == null) ? Colors.grey[300] : AppColors.googleBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Pay ₹$amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: (amount == '0' || selectedBankAccount == null) ? Colors.grey[600] : Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildNumpadSheet() {
    return Container(
      color: Colors.white,
      child: Numpad(
        onKeyPressed: _onKeyPressed,
        onDelete: _onDelete,
        onClear: _onClear,
      ),
    );
  }

  void _showBankSelectionSheet(List<BankAccount> accounts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Select account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  final isSelected = selectedBankAccount?.id == account.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBankAccount = account;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: isSelected ? AppColors.googleBlue.withOpacity(0.05) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              LucideIcons.building2,
                              color: AppColors.googleBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.bankName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Savings account',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.googleBlue,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
   );}
  }
