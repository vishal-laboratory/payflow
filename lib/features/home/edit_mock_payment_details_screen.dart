import 'package:flutter/material.dart';

import '../../core/data/contact_store.dart';
import '../../core/data/mock_data.dart';
import '../../core/data/mock_payment_config.dart';
import '../../core/theme/app_colors.dart';
import '../payment/send_money_screen.dart';

class EditMockPaymentDetailsScreen extends StatefulWidget {
  const EditMockPaymentDetailsScreen({super.key});

  @override
  State<EditMockPaymentDetailsScreen> createState() =>
      _EditMockPaymentDetailsScreenState();
}

class _EditMockPaymentDetailsScreenState
    extends State<EditMockPaymentDetailsScreen> {
  late final TextEditingController _toReceiverNameController;
  late final TextEditingController _toReceiverUpiController;
  late DateTime _selectedDateTime;
  bool _saveToPeople = false;
  bool _useCurrentTime = true;

  @override
  void initState() {
    super.initState();
    _toReceiverNameController = TextEditingController(text: '');
    _toReceiverUpiController = TextEditingController(text: '');
    _selectedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    _toReceiverNameController.dispose();
    _toReceiverUpiController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_toReceiverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter receiver name'),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    if (_toReceiverUpiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter receiver UPI ID'),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    final receiverName = _toReceiverNameController.text.trim();
    final transactionTime = _useCurrentTime ? DateTime.now() : _selectedDateTime;

    // Auto-generate transaction IDs and bank details
    final upiRRN = MockPaymentConfig.generateUpiRRN();
    final googleTxnId = MockPaymentConfig.generateGoogleTransactionId();

    // Update mock config
    MockPaymentConfig.update(
      receiverName: receiverName,
      bankName: MockPaymentConfig.bankName,
      bankLast4: MockPaymentConfig.bankLast4,
      upiTransactionId: upiRRN,
      toReceiverName: receiverName,
      toReceiverUpiId: _toReceiverUpiController.text,
      fromPayerName: MockPaymentConfig.fromPayerName,
      fromPayerUpiId: MockPaymentConfig.fromPayerUpiId,
      googleTransactionId: googleTxnId,
      transactionDateTime: transactionTime,
    );

    if (_saveToPeople) {
      ContactStore.addReceiverIfMissing(
        name: receiverName,
        upiId: _toReceiverUpiController.text,
      );
    }

    final contact = Contact(
      name: receiverName,
      upiId: _toReceiverUpiController.text,
      gradient: AppColors.gradientRahul,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SendMoneyScreen(contact: contact)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enter Payment Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              _buildField(_toReceiverNameController, 'Receiver name'),
              _buildField(_toReceiverUpiController, 'Receiver UPI ID'),
              const SizedBox(height: 16),
              // Transaction Time Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Time',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _useCurrentTime = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: _useCurrentTime
                                    ? AppColors.googleBlue
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _useCurrentTime
                                      ? AppColors.googleBlue
                                      : const Color(0xFFE0E0E0),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Current Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _useCurrentTime
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _useCurrentTime = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: !_useCurrentTime
                                    ? AppColors.googleBlue
                                    : Colors.transparent,
                                border: Border.all(
                                  color: !_useCurrentTime
                                      ? AppColors.googleBlue
                                      : const Color(0xFFE0E0E0),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Manual Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: !_useCurrentTime
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!_useCurrentTime) ...[
                      const SizedBox(height: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _pickDateTime(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Select date & time',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _formatDateTime(_selectedDateTime),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              const Icon(Icons.calendar_today_outlined, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSaveToPeopleCheckbox(),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.googleBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Next >',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.googleBlue, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveToPeopleCheckbox() {
    return CheckboxListTile(
      value: _saveToPeople,
      onChanged: (value) {
        setState(() {
          _saveToPeople = value ?? false;
        });
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text(
        'Save receiver in People section',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      activeColor: AppColors.googleBlue,
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (selectedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  String _formatDateTime(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final meridiem = dateTime.hour >= 12 ? 'pm' : 'am';

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, '
        '$hour12:$minute $meridiem';
  }
}