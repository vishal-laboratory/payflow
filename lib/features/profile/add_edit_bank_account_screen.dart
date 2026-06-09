import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/bank_account_store.dart';
import '../../core/models/bank_account.dart';
import '../../core/theme/app_colors.dart';

class AddEditBankAccountScreen extends StatefulWidget {
  final BankAccount? bankAccount;

  const AddEditBankAccountScreen({
    super.key,
    this.bankAccount,
  });

  @override
  State<AddEditBankAccountScreen> createState() =>
      _AddEditBankAccountScreenState();
}

class _AddEditBankAccountScreenState extends State<AddEditBankAccountScreen> {
  late TextEditingController accountNumberController;
  late TextEditingController upiIdController;
  String? selectedBank;
  String? errorMessage;
  bool isLoading = false;

  final bankList = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'IDBI Bank',
    'Bank of India',
    'Central Bank of India',
    'Indian Bank',
    'Union Bank of India',
    'Bank of Baroda',
    'Canara Bank',
    'Punjab National Bank',
    'IndusInd Bank',
    'Kotak Mahindra Bank',
    'City Union Bank',
    'Federal Bank',
    'RBL Bank',
    'ICICI Prudential',
    'YES Bank',
    'South Indian Bank',
    'Karur Vysya Bank',
    'DCB Bank',
    'Equitas Small Finance Bank',
    'Bandhan Bank',
    'AU Small Finance Bank',
    'DBS Bank',
    'HSBC Bank',
    'Citibank',
    'India Post Payments Bank',
    'Ashok Leyland Finance',
    'Groww (Emerging Bank)',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.bankAccount != null) {
      selectedBank = widget.bankAccount!.bankName;
      accountNumberController = TextEditingController(
        text: widget.bankAccount!.accountNumber,
      );
      upiIdController = TextEditingController(
        text: widget.bankAccount!.upiId,
      );
    } else {
      accountNumberController = TextEditingController();
      upiIdController = TextEditingController();
    }
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    upiIdController.dispose();
    super.dispose();
  }

  bool _isValidAccountNumber(String accountNumber) {
    final trimmed = accountNumber.trim();
    return RegExp(r'^\d{9,18}$').hasMatch(trimmed);
  }

  bool _isValidUpiId(String upiId) {
    final trimmed = upiId.trim();
    return trimmed.contains('@');
  }

  Future<void> _saveAccount() async {
    setState(() => errorMessage = null);

    // Validation
    if (selectedBank == null || selectedBank!.isEmpty) {
      setState(() => errorMessage = 'Please select a bank');
      return;
    }

    if (accountNumberController.text.isEmpty) {
      setState(() => errorMessage = 'Please enter account number');
      return;
    }

    if (!_isValidAccountNumber(accountNumberController.text)) {
      setState(() => errorMessage = 'Account number must be 9-18 digits');
      return;
    }

    if (upiIdController.text.isEmpty) {
      setState(() => errorMessage = 'Please enter UPI ID');
      return;
    }

    if (!_isValidUpiId(upiIdController.text)) {
      setState(() => errorMessage = 'UPI ID must contain @');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (widget.bankAccount != null) {
        // Edit existing account
        final updatedAccount = widget.bankAccount!.copyWith(
          bankName: selectedBank!,
          accountNumber: accountNumberController.text.trim(),
          upiId: upiIdController.text.trim(),
        );
        await BankAccountStore.updateAccount(updatedAccount);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank account updated successfully!'),
              backgroundColor: Color(0xFF1E8E3E),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, updatedAccount);
        }
      } else {
        // Add new account
        final newAccount = BankAccount(
          id: const Uuid().v4(),
          bankName: selectedBank!,
          accountNumber: accountNumberController.text.trim(),
          ifscCode: '',
          upiId: upiIdController.text.trim(),
          createdAt: DateTime.now(),
        );

        await BankAccountStore.addAccount(newAccount);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank account added successfully!'),
              backgroundColor: Color(0xFF1E8E3E),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, newAccount);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => errorMessage = 'Error saving account: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bankAccount != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Bank Account' : 'Add Bank Account',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Banner
              if (errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    border: Border.all(color: const Color(0xFFEF5350), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFD32F2F),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => errorMessage = null),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFD32F2F),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Select Bank
              const Text(
                'Select Bank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedBank != null && bankList.contains(selectedBank) ? selectedBank : null,
                hint: const Text(
                  'Choose your bank',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: [
                  // Add currently selected bank if exists but not in main list
                  if (selectedBank != null && !bankList.contains(selectedBank))
                    DropdownMenuItem(
                      value: selectedBank,
                      child: Text(selectedBank!),
                    ),
                  // Add all predefined banks
                  ...bankList.map((bank) => DropdownMenuItem(
                        value: bank,
                        child: Text(bank),
                      )),
                ].toList(),
                onChanged: (value) {
                  setState(() => selectedBank = value);
                },
              ),
              const SizedBox(height: 20),

              // Account Number
              const Text(
                'Account Number (9-18 digits)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: 'e.g., 123456789012',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.googleBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // UPI ID
              const Text(
                'UPI ID (must contain @)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: upiIdController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'e.g., yourname@bankname',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.googleBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.googleBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          isEditing ? 'Update Account' : 'Add Account',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
