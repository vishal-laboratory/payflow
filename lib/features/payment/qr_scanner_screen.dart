import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import 'send_money_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isHandled = false;
  bool _cameraGranted = false;
  bool _checkingPermission = true;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _ensureCameraPermission();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _ensureCameraPermission() async {
    setState(() {
      _checkingPermission = true;
    });

    final status = await Permission.camera.request();

    if (!mounted) {
      return;
    }

    setState(() {
      _cameraGranted = status.isGranted;
      _checkingPermission = false;
    });
  }

  void _handleCode(String rawValue) {
    if (_isHandled) return;

    final parsed = _parseQr(rawValue);
    if (parsed == null) return;

    _isHandled = true;

    final contact = Contact(
      name: parsed.name,
      upiId: parsed.upiId,
      gradient: AppColors.gradientRahul,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SendMoneyScreen(contact: contact)),
    );
  }

  _ParsedQr? _parseQr(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    if (value.startsWith('upi://pay')) {
      final uri = Uri.tryParse(value);
      final upiId = uri?.queryParameters['pa']?.trim();
      final name = uri?.queryParameters['pn']?.trim();
      if (upiId != null && upiId.isNotEmpty) {
        return _ParsedQr(
          name: (name == null || name.isEmpty) ? 'UPI Receiver' : name,
          upiId: upiId,
        );
      }
    }

    final byLine = value.split('\n');
    String? name;
    String? upiId;
    for (final line in byLine) {
      final normalized = line.trim();
      if (normalized.contains('@') && upiId == null) {
        upiId = normalized;
      }
      if (normalized.toLowerCase().startsWith('name:')) {
        name = normalized.split(':').skip(1).join(':').trim();
      }
      if (normalized.toLowerCase().startsWith('upi:')) {
        upiId = normalized.split(':').skip(1).join(':').trim();
      }
    }

    if (upiId != null && upiId.isNotEmpty) {
      return _ParsedQr(
        name: (name == null || name.isEmpty) ? 'UPI Receiver' : name,
        upiId: upiId,
      );
    }

    return _ParsedQr(name: 'UPI Receiver', upiId: value);
  }

  @override
  Widget build(BuildContext context) {
    final showScanner = _cameraGranted && !_checkingPermission;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan QR'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (showScanner)
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final value = capture.barcodes.first.rawValue;
                if (value != null) {
                  _handleCode(value);
                }
              },
            )
          else
            _buildCameraFallback(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Scan a UPI QR code to continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 86,
            child: OutlinedButton(
              onPressed: _openManualInput,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
              ),
              child: const Text('Enter QR data manually'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraFallback() {
    if (_checkingPermission) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 44),
            const SizedBox(height: 12),
            const Text(
              'Camera preview unavailable',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Allow camera permission or use manual QR input.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _ensureCameraPermission,
              child: const Text('Retry Camera'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openManualInput() async {
    final controller = TextEditingController();

    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Paste QR data'),
          content: TextField(
            controller: controller,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'upi://pay?pa=...&pn=...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (text == null || text.trim().isEmpty) {
      return;
    }

    _handleCode(text);
  }
}

class _ParsedQr {
  final String name;
  final String upiId;

  const _ParsedQr({required this.name, required this.upiId});
}