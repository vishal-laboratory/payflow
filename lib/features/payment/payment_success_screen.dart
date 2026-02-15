import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    // Recipient Section
                    _buildRecipientSection(),
                    const SizedBox(height: 32),
                    // Bank Details Card
                    _buildBankDetailsCard(),
                    const SizedBox(height: 32),
                    // UPI Logo and Message
                    _buildUpiSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Bottom Sheet
            _buildBottomSheet(),
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
                  size: 18,
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
          width: 64,
          height: 64,
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
                        fontSize: 20,
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
        const SizedBox(height: 12),
        // Recipient Name
        Text(
          'To ${widget.details.payeeName}',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
           //b letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        // Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              widget.details.currencySymbol,
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
              ),
            ),

            Text(
              widget.details.amountText,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w500,
                //letterSpacing: -0.1,
                color: AppColors.textPrimary,
              ),
            ),

          ],
        ),
        const SizedBox(height:28),
        // Pay again button
        SizedBox(
          width: 130,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0E56CF), //AppColors.googleBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 2,
              shadowColor: const Color(0x331A73E8),
            ),
            child: const Text(
              'Pay again',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Status
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 18,
              color: Color(0xFF1E8E3E),
            ),
            const SizedBox(width: 8),
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
        const SizedBox(height: 14),
        Container(
          width: 200,
          height: 0.5,
          color: const Color(0xFFc4c7c5),
        ),
        const SizedBox(height: 13),
        // Date/Time
        Text(
          widget.details.dateTimeText,
          style: const TextStyle(
            fontSize: 15,
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
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Bank Logo
                    Container(
                      width: 46,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFc4c7c5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: widget.details.bankLogoUrl == null
                          ? Text(
                              widget.details.bankLogoLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.details.bankLogoColor,
                              ),
                            )
                          : Image.network(
                              widget.details.bankLogoUrl!,
                              width: 46,
                              height: 28,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Text(
                                widget.details.bankLogoLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.details.bankLogoColor,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Bank Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.details.bankName} ••••${widget.details.bankLast4}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chevron
                    AnimatedRotation(
                      turns: _showBankDetails ? 0 : 0.25,
                      duration: const Duration(milliseconds: 150),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                        size: 24,
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
                    const SizedBox(height: 20),
                    _buildDetailItem(
                      'To: ${widget.details.toName}',
                      'Google Pay • ${widget.details.toVpa}',
                      isSmall: true,
                      bold: true,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailItem(
                      'From: ${widget.details.fromName}',
                      'Google Pay • ${widget.details.fromVpa}',
                      isSmall: true,
                      bold: true,
                    ),
                    const SizedBox(height: 20),
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

  Widget _buildDetailItem(String label, String value, {bool isSmall = false, bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight:  FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize : 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF323232),
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
            width: 64,
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      height: 88,

      child: Row(
        children: [
          // Help Button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF909090), width: 1),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.helpCircle,
                    color: AppColors.textPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Having issues?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
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
}
