import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String phoneNumber;
  final String avatarLabel;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.phoneNumber,
    required this.avatarLabel,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController messageController;
  final List<ChatMessage> messages = [
    ChatMessage(
      type: ChatMessageType.paymentSent,
      title: 'Payment to Nolan',
      amount: '₹3,000',
      status: 'Paid • 16 Mar',
      date: '16 Mar, 9:40 pm',
    ),
    ChatMessage(
      type: ChatMessageType.scratchCard,
      title: 'You earned a scratch card!',
      date: '16 Mar, 9:40 pm',
    ),
    ChatMessage(
      type: ChatMessageType.paymentReceived,
      title: 'Payment to you',
      amount: '₹3,000',
      status: 'Paid • 16 Mar',
      date: '21 Mar, 8:24 am',
    ),
    ChatMessage(
      type: ChatMessageType.paymentReceived,
      title: 'Payment to you',
      amount: '₹3,000',
      date: '21 Mar, 8:24 am',
    ),
  ];

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Avatar(
              label: widget.avatarLabel,
              gradient: AppColors.gradientRahul,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.phone, color: AppColors.googleBlue, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical, color: AppColors.textPrimary, size: 20),
            onPressed: () {
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final prevMessage = index > 0 ? messages[index - 1] : null;
                final showDateDivider = prevMessage == null || prevMessage.date != message.date;

                return Column(
                  children: [
                    if (showDateDivider) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                message.date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          ],
                        ),
                      ),
                    ],
                    _buildMessageBubble(message),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.googleBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.googleBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.send, color: AppColors.googleBlue, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    switch (message.type) {
      case ChatMessageType.paymentSent:
      case ChatMessageType.paymentReceived:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (message.type == ChatMessageType.paymentReceived)
                      Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message.amount ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Color(0xFF1E8E3E),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      message.status ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case ChatMessageType.scratchCard:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5B9FFF),
                        Color(0xFF1573E8),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 20,
                        child: Icon(
                          Icons.flutter_dash,
                          size: 40,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 25,
                        child: Icon(
                          Icons.card_giftcard,
                          size: 35,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tap to view',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }
}

enum ChatMessageType {
  paymentSent,
  paymentReceived,
  scratchCard,
}

class ChatMessage {
  final ChatMessageType type;
  final String title;
  final String? amount;
  final String? status;
  final String date;

  ChatMessage({
    required this.type,
    required this.title,
    this.amount,
    this.status,
    required this.date,
  });
}
