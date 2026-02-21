import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

import '../../core/data/mock_payment_config.dart';
import '../../core/theme/app_colors.dart';
import 'models/payment_details.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final PaymentDetails details;

  const PaymentSuccessScreen({super.key, required this.details});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _showBankDetails = true;
  late ScrollController _scrollController;
  bool _showBottomSheet = true;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    // Hide bottom sheet when scrolling up, show when scrolling down
    final newShowBottomSheet = !(_scrollController.position.pixels > 50);
    if (newShowBottomSheet != _showBottomSheet) {
      setState(() {
        _showBottomSheet = newShowBottomSheet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Top Bar
            _buildHeaderBar(),
            Expanded(
              child: RepaintBoundary(
                key: _repaintBoundaryKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Recipient Section
                      _buildRecipientSection(),
                      const SizedBox(height: 34),
                      // Bank Details Card
                      _buildBankDetailsCard(),
                      const SizedBox(height: 1),
                      // UPI Logo and Message
                      _buildUpiSection(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Sheet - Hide/Show on scroll
            ClipRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showBottomSheet ? 100 : 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: _buildBottomSheet(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  LucideIcons.arrowLeft,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
            const Spacer(),
            // Download Button
            GestureDetector(
              onTap: () {},
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  LucideIcons.flag,
                  color: AppColors.textPrimary,
                  size: 17,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Menu Button
            GestureDetector(
              onTap: () {},
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  LucideIcons.moreVertical,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientSection() {
    return Column(
      children: [
        // Avatar with Border
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.details.payeeColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: widget.details.payeeImageUrl == null
                ? Container(
                    color: widget.details.payeeColor,
                    alignment: Alignment.center,
                    child: Text(
                      widget.details.payeeInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                    ),
                  )
                : Image.network(
                    widget.details.payeeImageUrl!,
              width: 64,
              height: 64,

              fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: widget.details.payeeColor,
                      alignment: Alignment.center,
                      child: Text(
                        widget.details.payeeInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        // Recipient Name
        Text(
          'To ${widget.details.payeeName}',
          style: const TextStyle(

            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            height:1

          ),
        ),
        const SizedBox(height: 14),
        // Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Transform.translate(
              offset: const Offset(0, -7),
              child: Text(
                widget.details.currencySymbol,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                 // height: 1.1,
                  color: AppColors.textPrimary,
                ),
              ),
            ),


            Text(
              widget.details.amountText,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),

          ],
        ),

        const SizedBox(height: 22),

        SizedBox(
          height: 44, //
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E56CF),
              elevation: 1.5, // softer shadow
              padding: const EdgeInsets.symmetric(horizontal: 20), // better than fixed width
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22), // slightly smaller
              ),
            ),
            child: const Text(
              'Pay again',
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.w500, // lighter weight
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 18,
              color: Color(0xFF1E8E3E),
            ),
            const SizedBox(width: 6),
            Text(
              widget.details.statusText,
              style: const TextStyle(
                fontSize: 15,
                //fontWeight: FontWeight.w400,
                color: Color(0xFF020202),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 180,
          height: 0.5,
          color: const Color(0xFFc4c7c5),
        ),
        const SizedBox(height: 14),
        // Date/Time
        Text(
          widget.details.dateTimeText,
          style: const TextStyle(
            fontSize: 14,
            //fontWeight: FontWeight.w400,
            color: Color(0xFF020202),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:  Color(0xFFc4c7c5), width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),

            ),
          ],
        ),
        child: Column(
          children: [
            // Bank Header
            GestureDetector(
              onTap: () => setState(() => _showBankDetails = !_showBankDetails),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                // child: Row(
                //   children: [
                //     // Bank Logo
                //     Container(
                //       width: 46,
                //       height: 28,
                //       decoration: BoxDecoration(
                //         border: Border.all(
                //           color: const Color(0xFFc4c7c5),
                //           width: 1,
                //         ),
                //         borderRadius: BorderRadius.circular(4),
                //         color: Colors.white,
                //       ),
                //       alignment: Alignment.center,
                //       child: _buildBankLogo(),
                //     ),
                //     const SizedBox(width: 16),
                //     // // Bank Name
                //     // Expanded(
                //     //   child: Column(
                //     //     crossAxisAlignment: CrossAxisAlignment.start,
                //     //     children: [
                //     //       Text(
                //     //         '${widget.details.bankName}\n ${widget.details.bankLast4}',
                //     //
                //     //         //overflow: TextOverflow.ellipsis,
                //     //         style: const TextStyle(
                //     //             fontSize: 16,
                //     //             fontWeight: FontWeight.w600,
                //     //             color: Color(0xFF202124),
                //     //
                //     //
                //     //         ),
                //     //       ),
                //     //     ],
                //     //   ),
                //     // ),
                //
                //
                //
                //     // Chevron
                //     AnimatedRotation(
                //       turns: _showBankDetails ? 0 : 0.25,
                //       duration: const Duration(milliseconds: 150),
                //       child: const Icon(
                //         Icons.keyboard_arrow_down,
                //         color: AppColors.textSecondary,
                //         size: 24,
                //       ),
                //     ),
                //   ],
                // ),

                  child: Row(
                    children: [
                      // Logo
                      Container(
                        width: 46,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFc4c7c5)),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: _buildBankLogo(),
                      ),

                      const SizedBox(width: 16),

                      // Text takes ONLY remaining middle space
                      Expanded(
                        child: Text(
                          '${widget.details.bankName} ${widget.details.bankLast4}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF202124),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Fixed chevron slot
                      SizedBox(
                        width: 32, // fixed reserved space
                        child: AnimatedRotation(
                          turns: _showBankDetails ? 0 : 0.25,
                          duration: const Duration(milliseconds: 150),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            if (_showBankDetails) ...[
              Container(height: 1, color:AppColors.divider),
              // Bank Details Content
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailItem(
                      'UPI transaction ID',
                      widget.details.upiTxnId,
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'To: ${widget.details.toName}',
                      'Google Pay • ${widget.details.toVpa}',
                      isSmall: true,
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'From: ${widget.details.fromName} (${widget.details.bankName})',
                      'Google Pay • ${widget.details.fromVpa}',
                      isSmall: true,
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'Google transaction ID',
                      widget.details.googleTxnId,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBankLogo() {
    final logoPath =
         MockPaymentConfig.logoForBankName(widget.details.bankName);

    return Center(
      child: Image.asset(
        logoPath,
        width: 46,
        height: 28,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        gaplessPlayback: true,
        // errorBuilder: (_, __, ___) => const SizedBox(
        //   width: 44,
        //   height: 26,
        //   child: Icon(
        //     Icons.account_balance,
        //     size: 16,
        //     color: AppColors.textSecondary,
        //   ),
        // ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isSmall = false, bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202124),
              letterSpacing: 0
            //color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF202124),
           // letterSpacing: isSmall ? 1 : 0,
          ),
        ),
      ],
    );
  }

  Widget _buildUpiSection() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/poweredbyupi.png',
            width: 80,
            color: Colors.black, // forces logo to black
            colorBlendMode: BlendMode.srcIn,
          ),
        ),

      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFEAEAEA), width: 1),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Having Issues Button
          _buildBottomSheetButton(
            icon: LucideIcons.helpCircle,
            label: 'Having issues?',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // Share Button
          _buildBottomSheetButton(
            icon: LucideIcons.share2,
            label: 'Share',
            onTap: _captureAndShare,
          ),
          // Split Expenses Button
          _buildBottomSheetButton(
            icon: LucideIcons.users,
            label: 'Split',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.googleBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.googleBlue,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndShare() async {
    try {
      final boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null && mounted) {
        final pngBytes = byteData.buffer.asUint8List();
        await Share.shareXFiles(
          [XFile.fromData(pngBytes, mimeType: 'image/png', name: 'payment_receipt.png')],
          text: 'Payment to ${widget.details.payeeName} - ₹${widget.details.amountText}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }
}
