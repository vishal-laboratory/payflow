import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late TextEditingController searchController;
  
  final List<ChatConversation> conversations = [
    ChatConversation(
      name: 'Vishal',
      phoneNumber: '+91 85845 46858',
      avatarLabel: 'V',
      lastMessage: 'Sent to Vishal',
      lastAmount: '₹455.00',
      lastTime: '7:1 pm, 2:15 pm',
      status: 'Paid',
      isActive: true,
    ),
    ChatConversation(
      name: 'Nolan Korsgaard',
      phoneNumber: '+91 92847 56934',
      avatarLabel: 'N',
      lastMessage: 'Payment to Nolan',
      lastAmount: '₹3,000',
      lastTime: '16 Mar, 9:40 pm',
      status: 'Paid',
      isActive: false,
    ),
    ChatConversation(
      name: 'Rajesh Kumar',
      phoneNumber: '+91 98765 43210',
      avatarLabel: 'R',
      lastMessage: 'Received from Rajesh',
      lastAmount: '₹2,500',
      lastTime: '15 Mar, 3:30 pm',
      status: 'Received',
      isActive: true,
    ),
    ChatConversation(
      name: 'Priya Singh',
      phoneNumber: '+91 87654 32109',
      avatarLabel: 'P',
      lastMessage: 'Payment to Priya',
      lastAmount: '₹1,200',
      lastTime: '14 Mar, 6:45 pm',
      status: 'Paid',
      isActive: false,
    ),
    ChatConversation(
      name: 'Amit Patel',
      phoneNumber: '+91 76543 21098',
      avatarLabel: 'A',
      lastMessage: 'Received from Amit',
      lastAmount: '₹5,000',
      lastTime: '13 Mar, 11:20 am',
      status: 'Received',
      isActive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
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
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search, color: AppColors.googleBlue, size: 20),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  LucideIcons.search,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Chat List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                return _buildChatTile(conversations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(ChatConversation chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              contactName: chat.name,
              phoneNumber: chat.phoneNumber,
              avatarLabel: chat.avatarLabel,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Avatar(
                      label: chat.avatarLabel,
                      gradient: AppColors.gradientRahul,
                      size: 56,
                    ),
                    if (chat.isActive)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E8E3E),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            chat.lastAmount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E8E3E).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              chat.status,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E8E3E),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat.lastTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[200],
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Chats'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by name or phone...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class ChatConversation {
  final String name;
  final String phoneNumber;
  final String avatarLabel;
  final String lastMessage;
  final String lastAmount;
  final String lastTime;
  final String status;
  final bool isActive;

  ChatConversation({
    required this.name,
    required this.phoneNumber,
    required this.avatarLabel,
    required this.lastMessage,
    required this.lastAmount,
    required this.lastTime,
    required this.status,
    required this.isActive,
  });
}
