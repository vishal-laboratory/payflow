import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/action_card.dart';
import '../../core/data/contact_store.dart';
import '../../core/data/mock_data.dart';
import '../../core/data/transaction_store.dart';
import '../../core/data/mock_payment_config.dart';
import '../chat/chat_screen.dart';
import 'edit_mock_payment_details_screen.dart';
import 'people_chat_screen.dart';
import '../payment/qr_scanner_screen.dart';
import '../recharge/mobile_recharge_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(child: _buildBalanceCard(context)),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Quick Actions', null),
            ),
            _buildQuickActionsGrid(context),
            SliverToBoxAdapter(child: _buildSectionHeader('People', 'See All')),
            SliverToBoxAdapter(child: _buildContactsList()),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                'Transactions',
                'See All',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),
            ),
            _buildTransactionsList(),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final String greeting = _getGreeting();
    final String userName = MockPaymentConfig.fromPayerName;
    final String userInitials = MockPaymentConfig.getInitials();

    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      pinned: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Avatar(
            label: userInitials,
            gradient: AppColors
                .gradientMom, // Using Mom's gradient as placeholder for user
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(LucideIcons.bell, color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: const Icon(LucideIcons.user, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '24,850',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '.00',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceAction(context, LucideIcons.send, 'Send', 
               onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditMockPaymentDetailsScreen(),
                          ),
                        );
                      },),
              _buildBalanceAction(context, LucideIcons.download, 'Receive'),
              _buildBalanceAction(
                context,
                LucideIcons.scanLine,
                'Scan',
                onTap: () => _openQrScanner(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceAction(
    BuildContext context,
    IconData icon,
    String label,
    {VoidCallback? onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _openQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
  }

  Future<void> _onContactLongPress(
    BuildContext context,
    Contact contact, {
    required bool isSavedContact,
  }) async {
    if (!isSavedContact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default contact cannot be removed'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final shouldRemove = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove from People'),
                onTap: () => Navigator.pop(sheetContext, true),
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(sheetContext, false),
              ),
            ],
          ),
        );
      },
    );

    if (shouldRemove == true) {
      await ContactStore.removeSavedContact(contact.name);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${contact.name} removed from People'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildSectionHeader(
    String title,
    String? action, {
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {'icon': LucideIcons.smartphone, 'label': 'Recharge'},
      {'icon': LucideIcons.fileText, 'label': 'Bills'},
      {'icon': LucideIcons.zap, 'label': 'Electricity'},
      {'icon': LucideIcons.tv, 'label': 'DTH'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final label = actions[index]['label'] as String;
          return ActionCard(
            icon: actions[index]['icon'] as IconData,
            label: label,
            onTap: () {
              if (label == 'Recharge') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MobileRechargeScreen(),
                  ),
                );
              }
            },
          );
        }, childCount: actions.length),
      ),
    );
  }

  Widget _buildContactsList() {
    return ValueListenableBuilder<int>(
      valueListenable: ContactStore.changes,
      builder: (context, _, __) {
        final allContacts = <Contact>[
          ...MockData.contacts,
          ...ContactStore.savedContacts,
        ];

        return SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: allContacts.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index == allContacts.length) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditMockPaymentDetailsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.borderLight, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'More',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }

              final contact = allContacts[index];
              final isSavedContact = index >= MockData.contacts.length;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PeopleChatScreen(contact: contact),
                        ),
                      );
                    },
                    onLongPress: () {
                      _onContactLongPress(
                        context,
                        contact,
                        isSavedContact: isSavedContact,
                      );
                    },
                    child: Avatar(
                      label: contact.name,
                      gradient: contact.gradient,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList() {
    return SliverToBoxAdapter(
      child: ValueListenableBuilder<int>(
        valueListenable: TransactionStore.changes,
        builder: (context, _, __) {
          final combined = <_HomeTransactionEntry>[
            ...TransactionStore.allRecords.map(
              (record) => _HomeTransactionEntry(
                title: 'To ${record.receiverName}',
                date: TransactionStore.formatForHistory(record.createdAt),
                amount: record.amount,
                isCredit: false,
              ),
            ),
            ...MockData.transactions.map(
              (transaction) => _HomeTransactionEntry(
                title: transaction.title,
                date: transaction.date,
                amount: transaction.amount,
                isCredit: transaction.isCredit,
              ),
            ),
          ];

          return Column(
            children: List.generate(combined.length, (index) {
              final transaction = combined[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: transaction.isCredit
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            transaction.isCredit
                                ? LucideIcons.arrowDownLeft
                                : LucideIcons.arrowUpRight,
                            color: transaction.isCredit
                                ? AppColors.success
                                : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction.date,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${transaction.isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: transaction.isCredit
                                ? AppColors.success
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < combined.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        color: AppColors.borderLight,
                      ),
                    ),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppColors.surface,
      shadowColor: Colors.black.withOpacity(0.08),
      elevation: 8,
      height: 70,
      selectedIndex: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          );
        } else if (index == 2) {
          _openQrScanner(context);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(LucideIcons.home),
          label: 'Home',
          tooltip: 'Home',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.history),
          label: 'History',
          tooltip: 'History',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.scanLine),
          label: 'Scan',
          tooltip: 'Scan',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.creditCard),
          label: 'Cards',
          tooltip: 'Cards',
        ),
      ],
    );
  }
}

class _HomeTransactionEntry {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  const _HomeTransactionEntry({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}
