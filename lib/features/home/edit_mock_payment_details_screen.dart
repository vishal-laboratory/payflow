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
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankLast4Controller;
  late final TextEditingController _upiTxnIdController;
  late final TextEditingController _toReceiverNameController;
  late final TextEditingController _toReceiverUpiController;
  late final TextEditingController _fromPayerNameController;
  late final TextEditingController _fromPayerUpiController;
  late final TextEditingController _googleTxnIdController;
  String? _selectedBankName;
  late DateTime _selectedDateTime;
  bool _saveToPeople = false;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController(text: MockPaymentConfig.bankName);
    _selectedBankName = MockPaymentConfig.bankOptions
        .where((option) => option.name == MockPaymentConfig.bankName)
        .isNotEmpty
      ? MockPaymentConfig.bankName
      : null;
    _bankLast4Controller = TextEditingController(text: MockPaymentConfig.bankLast4);
    _upiTxnIdController = TextEditingController(
      text: MockPaymentConfig.upiTransactionId,
    );
    _toReceiverNameController = TextEditingController(
      text: MockPaymentConfig.toReceiverName.isNotEmpty
          ? MockPaymentConfig.toReceiverName
          : MockPaymentConfig.receiverName,
    );
    _toReceiverUpiController = TextEditingController(
      text: MockPaymentConfig.toReceiverUpiId,
    );
    _fromPayerNameController = TextEditingController(
      text: MockPaymentConfig.fromPayerName,
    );
    _fromPayerUpiController = TextEditingController(
      text: MockPaymentConfig.fromPayerUpiId,
    );
    _googleTxnIdController = TextEditingController(
      text: MockPaymentConfig.googleTransactionId,
    );
    _selectedDateTime = MockPaymentConfig.transactionDateTime;
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _bankLast4Controller.dispose();
    _upiTxnIdController.dispose();
    _toReceiverNameController.dispose();
    _toReceiverUpiController.dispose();
    _fromPayerNameController.dispose();
    _fromPayerUpiController.dispose();
    _googleTxnIdController.dispose();
    super.dispose();
  }

  void _onNext() {
    final receiverName = _toReceiverNameController.text.trim();

    MockPaymentConfig.update(
      receiverName: receiverName,
      bankName: _bankNameController.text,
      bankLast4: _bankLast4Controller.text,
      upiTransactionId: _upiTxnIdController.text,
      toReceiverName: receiverName,
      toReceiverUpiId: _toReceiverUpiController.text,
      fromPayerName: _fromPayerNameController.text,
      fromPayerUpiId: _fromPayerUpiController.text,
      googleTransactionId: _googleTxnIdController.text,
      transactionDateTime: _selectedDateTime,
    );

    if (_saveToPeople) {
      ContactStore.addReceiverIfMissing(
        name: receiverName,
        upiId: _toReceiverUpiController.text,
      );
    }

    final sendName = receiverName;

    final contact = Contact(
      name: sendName.isEmpty ? 'Receiver' : sendName,
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
        title: const Text(' Enter Payment Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              _buildField(_toReceiverNameController, 'Receiver name'),
              _buildBankNameSelector(),
              _buildField(_bankLast4Controller, 'Bank a/c no (last 4)'),
              _buildField(_upiTxnIdController, 'UPI transaction ID'),
              _buildField(_toReceiverUpiController, 'To: Receiver UPI ID'),
              _buildField(_fromPayerNameController, 'From: Payer name'),
              _buildField(_fromPayerUpiController, 'From: Payer UPI ID'),
              _buildField(_googleTxnIdController, 'Google transaction ID'),
              _buildDateTimeSelector(context),
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

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.googleBlue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildBankNameSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedBankName,
        decoration: const InputDecoration(
          labelText: 'Bank name',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.googleBlue, width: 1.5),
          ),
        ),
        items: MockPaymentConfig.bankOptions
            .map(
              (option) => DropdownMenuItem<String>(
                value: option.name,
                child: Text(option.name),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          final selectedOption = MockPaymentConfig.bankOptions.firstWhere(
            (option) => option.name == value,
          );
          setState(() {
            _selectedBankName = value;
            _bankNameController.text = selectedOption.name;
          });
        },
      ),
    );
  }

  Widget _buildDateTimeSelector(BuildContext context) {
    final formatted = _formatDateTime(_selectedDateTime);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _pickDateTime(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Transaction date & time',
            border: OutlineInputBorder(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatted,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
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