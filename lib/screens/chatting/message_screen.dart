import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/chat/conversation.dart';
import 'package:e_commerce/providers/notifications_count/notification_badge_provider.dart';
import 'package:e_commerce/screens/chatting/chat_screen.dart';
import 'package:e_commerce/screens/chatting/message_item_shimmer.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/chatting/chatting_provider.dart';

import '../../utils/date_and_time_formatting.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChattingProvider>(context, listen: false)
          .fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: Consumer<ChattingProvider>(
        builder: (context, chattingProvider, _) {
          if (chattingProvider.isConversationFetchingLoading) {
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: 3,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: MessageItemShimmer(),
              ),
            );
          }
    
          return chattingProvider.conversations.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chattingProvider.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation =
                        chattingProvider.conversations[index];
                    return _buildMessageItem(
                      conversation: conversation,
                      name:
                          "${conversation.otherUser?.firstName} ${conversation.otherUser?.lastName}",
                      message: conversation.messages!.isEmpty
                          ? " "
                          : conversation.messages!.last.text,
                      date: conversation.messages!.isEmpty
                          ? " "
                          : formatDateWithTime(
                              conversation.messages!.last.createdAt
                                  .toString(),
                            ),
                      time: conversation.messages!.isEmpty
                          ? " "
                          : getFormattedTime12Hour(
                              conversation.messages!.last.createdAt
                                  .toString(),
                            ),
                      avatarColor: AppTheme.fMainColor,
                      avatarUrl: conversation.otherUser!.profilePicture,
                    );
                  },
                )
              : const Center(
                  child: Text("No messages yet!"),
                );
        },
      ),
    );
  }

  Widget _buildMessageItem({
    required Conversation conversation,
    String? avatarText,
    String? avatarUrl,
    required String name,
    required String message,
    required String time,
    required Color avatarColor,
    required String date,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Truncate the message if it's too long
    String truncatedMessage =
        message.length > 80 ? "${message.substring(0, 80)}..." : message;

    return GestureDetector(
      onTap: () {
        // Navigate to ChatScreen or any other screen on message tap
        Navigator.of(context).push(
          SlidePageRoute(
            page: ChatScreen(
              conversation: conversation,
            ),
          ),
        );
      },
      child: CardyContainer(
        color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.only(bottom: 16),
        spreadRadius: 0,
        blurRadius: 1,
        shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Avatar
              avatarUrl != null
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(avatarUrl),
                      radius: 24,
                    )
                  : CircleAvatar(
                      backgroundColor: avatarColor,
                      radius: 24,
                      child: Text(
                        avatarText ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(width: 12),
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          date,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const Text(' - '),
                        Text(
                          time,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(truncatedMessage,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
