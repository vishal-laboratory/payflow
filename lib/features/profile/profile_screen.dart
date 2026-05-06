import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/data/mock_payment_config.dart';
import '../../core/data/bank_account_store.dart';
import '../../core/models/bank_account.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';
import 'add_edit_bank_account_screen.dart';


class ProfileScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const ProfileScreen({super.key, this.isFirstLaunch = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController senderNameController;
  late TextEditingController phoneController;
  bool isEditingProfile = false;

  @override
  void initState() {
    super.initState();
    // Load saved profile data from MockPaymentConfig
    senderNameController = TextEditingController(
      text: MockPaymentConfig.fromPayerName.trim().isEmpty
          ? ''
          : MockPaymentConfig.fromPayerName.trim(),
    );
    phoneController = TextEditingController(
      text: MockPaymentConfig.fromPayerPhone.trim().isEmpty
          ? ''
          : MockPaymentConfig.fromPayerPhone.trim(),
    );
  }

  @override
  void dispose() {
    senderNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: widget.isFirstLaunch
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(LucideIcons.arrowLeft,
                    color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(
          widget.isFirstLaunch ? 'Get Started' : 'Profile',
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
          child: Column(
            children: [
              const SizedBox(height: 16),
              // First Launch Banner
              if (widget.isFirstLaunch)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.googleBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.googleBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          color: AppColors.googleBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Complete your profile',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Add your details to start using PayFlow',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              // User Profile Header
              _buildUserHeader(),
              const SizedBox(height: 24),
              // Rewards Section
              _buildRewardsSection(),
              const SizedBox(height: 24),
              // Payment Methods Setup
              _buildPaymentMethodsSetup(),
              const SizedBox(height: 24),
              // Menu Items
              _buildMenuItems(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    if (isEditingProfile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Sender Name
            TextField(
              controller: senderNameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Phone Number
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Enter 10-digit mobile number',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => isEditingProfile = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save profile data to SharedPreferences
                      MockPaymentConfig.updateUserProfile(
                        fullName: senderNameController.text,
                        phoneNumber: phoneController.text,
                      );
                      await MockPaymentConfig.saveUserProfile();
                      setState(() => isEditingProfile = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: Color(0xFF1E8E3E),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.googleBlue,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                label: senderNameController.text.isNotEmpty
                    ? senderNameController.text[0].toUpperCase()
                    : 'A',
                gradient: AppColors.gradientRahul,
                size: 64,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderNameController.text.trim().isEmpty
                          ? 'Add name'
                          : senderNameController.text.trim(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // UPI ID from Primary Bank Account
                    ValueListenableBuilder<List<BankAccount>>(
                      valueListenable: BankAccountStore.accountsNotifier,
                      builder: (context, accounts, _) {
                        final primaryUpi =
                            accounts.isNotEmpty ? accounts.first.upiId : 'No UPI';
                        return Row(
                          children: [
                            const Text(
                              'UPI ID:',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                primaryUpi,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    // Phone Number
                    Row(
                      children: [
                        Text(
                          phoneController.text.isEmpty
                              ? 'Add phone number'
                              : phoneController.text,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (phoneController.text.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E56CF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFF0E56CF),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF0E56CF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.edit,
                  color: AppColors.googleBlue,
                  size: 20,
                ),
                onPressed: () {
                  // Refresh controllers with latest saved data
                  senderNameController.text = MockPaymentConfig.fromPayerName.trim();
                  phoneController.text = MockPaymentConfig.fromPayerPhone.trim();
                  setState(() => isEditingProfile = true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFE082),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.card_giftcard, size: 18, color: Color(0xFFF57F17)),
                      SizedBox(width: 6),
                      Text(
                        '₹400',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF57F17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rewards earned',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFF57F17),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF81D4FA),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.card_giftcard, size: 18, color: Color(0xFF01579B)),
                      SizedBox(width: 6),
                      Text(
                        'get ₹200',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF01579B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rewards earned',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF01579B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSetup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bank account',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              // const Spacer(),
              // Icon(
              //   LucideIcons.chevronRight,
              //   size: 20,
              //   color: AppColors.textSecondary,
              // ),
            ],
          ),
          const SizedBox(height: 14),
          // Bank Account Card Only
          GestureDetector(
            onTap: _showBankBottomSheet,
            child: ValueListenableBuilder<List<BankAccount>>(
              valueListenable: BankAccountStore.accountsNotifier,
              builder: (context, accounts, _) {
                return _buildPaymentMethodCard(
                  icon: LucideIcons.building2,
                  title: 'Bank account',
                  subtitle: '${accounts.length} ${accounts.length == 1 ? 'account' : 'accounts'}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.googleBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: AppColors.googleBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: LucideIcons.creditCard,
        title: 'Pay with credit or debit cards',
        subtitle: 'Contactless payments, bills, and more',
      ),
      _MenuItem(
        icon: LucideIcons.qrCode,
        title: 'Your QR code',
        subtitle: 'use to receive money from any UPI app',
      ),
      _MenuItem(
        icon: LucideIcons.zap,
        title: 'Autopay',
        subtitle: 'No pending requests',
      ),
      _MenuItem(
        icon: LucideIcons.shield,
        title: 'UPI Circle',
        subtitle: 'Help people you trust make UPI payments',
      ),
      _MenuItem(
        icon: LucideIcons.settings,
        title: 'Settings',
        subtitle: '',
      ),
      _MenuItem(
        icon: LucideIcons.user,
        title: 'Manage Google account',
        subtitle: '',
      ),
      _MenuItem(
        icon: LucideIcons.helpCircle,
        title: 'Get help',
        subtitle: '',
      ),
      _MenuItem(
        icon: LucideIcons.globe,
        title: 'Language',
        subtitle: 'English',
      ),
    ];

    return Column(
      children: List.generate(
        menuItems.length,
        (index) => _buildMenuItem(menuItems[index]),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: AppColors.googleBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (item.subtitle.isNotEmpty)
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: const Color(0xFFEEEEEE),
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  void _showBankBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildBankBottomSheet(),
    );
  }

  Widget _buildBankBottomSheet() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Bank accounts',
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
            child: ValueListenableBuilder<List<BankAccount>>(
              valueListenable: BankAccountStore.accountsNotifier,
              builder: (context, accounts, _) {
                if (accounts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.building2,
                          size: 48,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No bank accounts added',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return _buildBankListItem(account);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddBankDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.googleBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add bank account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankListItem(BankAccount account) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditBankAccountScreen(bankAccount: account),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    '****${account.accountNumber.length >= 4 ? account.accountNumber.substring(account.accountNumber.length - 4) : account.accountNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.upiId,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditBankAccountScreen(bankAccount: account),
                      ),
                    );
                  },
                  child: const Icon(
                    LucideIcons.pencil,
                    color: AppColors.googleBlue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => BankAccountStore.removeAccount(account.id),
                  child: const Icon(
                    LucideIcons.trash2,
                    color: Color(0xFFD32F2F),
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBankDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditBankAccountScreen(),
      ),
    );
  }

}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
