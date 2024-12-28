import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/chat/conversation.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    final conversation = chattingProvider.conversations[index];
                    return _buildMessageItem(
                      conversation: conversation,
                      name:
                          "${conversation.otherUser?.firstName} ${conversation.otherUser?.lastName}",
                      message: "Hi There",
                      // conversation.messages!.isEmpty
                      //     ? " "
                      //     : conversation.messages!.last.text,
                      date: "25-10-2015",
                      //conversation.messages!.isEmpty
                      //  ? " "
                      // : formatDateWithTime(
                      //     conversation.messages!.last.createdAt.toString(),
                      //   ),
                      time: "10:00 AM",
                      // conversation.messages!.isEmpty
                      //     ? " "
                      //     : getFormattedTime12Hour(
                      //         conversation.messages!.last.createdAt.toString(),
                      //       ),
                      avatarColor: Theme.of(context).primaryColor,
                      avatarUrl:
                          //conversation.otherUser!.profilePicture ??
                          'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
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
    required String name,
    required String message,
    required String date,
    required String time,
    required Color avatarColor,
    String? avatarUrl,
  }) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(
            page: ChatScreen(conversation: conversation),
          ),
        );
      },
      child: CardyContainer(
        borderRadius: BorderRadius.circular(10),
        width: MediaQuery.of(context).size.width,
        color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
        spreadRadius: 0,
        blurRadius: 1,
        shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            backgroundColor: avatarColor,
          ),
          title: Text(name),
          subtitle: Text(message),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date, style: const TextStyle(fontSize: 12)),
              Text(time, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
