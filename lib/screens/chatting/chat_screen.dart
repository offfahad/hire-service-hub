import 'package:e_commerce/common/buttons/icon_gradient_button.dart';
import 'package:e_commerce/models/chat/conversation.dart';
import 'package:e_commerce/models/chat/messages.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/chatting/chatting_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize the socket connection with the authenticated user ID only if it's not already initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider =
          Provider.of<ChattingProvider>(context, listen: false);
      final authUserId =
          Provider.of<AuthenticationProvider>(context, listen: false).user!.id;

      // Load messages
      chatProvider
          .loadMessages(widget.conversation.id)
          .then((_) => _scrollToBottom());

      // Only initialize socket if not already initialized
      if (!chatProvider.isSocketInitialized) {
        chatProvider.initializeSocket(authUserId!);
      }

      // Scroll to the bottom whenever new messages arrive
      chatProvider.addListener(() {
        SchedulerBinding.instance
            .addPostFrameCallback((_) => _scrollToBottom());
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Disconnect socket when the app is in the background
      chatProvider.disconnectSocket();
    }

    if (state == AppLifecycleState.resumed) {
      // Only initialize socket if it's not already initialized
      if (!chatProvider.isSocketInitialized) {
        final authUserId =
            Provider.of<AuthenticationProvider>(context, listen: false)
                .user!
                .id;
        chatProvider.initializeSocket(authUserId!);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didpop) {
        //Disconnect the socket before navigating back
        final chatProvider =
            Provider.of<ChattingProvider>(context, listen: false);
        chatProvider.disconnectSocket();
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                final chatProvider =
                    Provider.of<ChattingProvider>(context, listen: false);
                chatProvider.disconnectSocket();
                Navigator.pop(context);
              },
              child: const Icon(IconlyLight.arrow_left),
            ),
            forceMaterialTransparency: true,
            title: Text(
              "${widget.conversation.otherUser?.firstName} ${widget.conversation.otherUser?.lastName}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          body: SafeArea(
            child: Consumer2<ChattingProvider, AuthenticationProvider>(
              builder: (context, chatProvider, authProvider, _) {
                // Retrieve the authenticated user's ID
                final authUserId = authProvider.user!.id;
                // Get the receiver's ID by finding the ID in members that isn't the auth user's ID
                final receiverId = widget.conversation.members
                    .firstWhere((id) => id != authUserId);

                return Column(
                  children: [
                    Expanded(
                      child: chatProvider.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: AppTheme.fMainColor),
                            )
                          : chatProvider.messages.isEmpty
                              ? const Center(child: Text('Say Hii! 👋'))
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  reverse:
                                      true, // Reverses the list to start at the bottom
                                  itemCount: chatProvider.messages.length,
                                  itemBuilder: (context, index) {
                                    final message = chatProvider.messages[
                                        chatProvider.messages.length -
                                            1 -
                                            index];
                                    bool isMyMessage =
                                        message.senderId == authUserId;
                                    return _buildMessageBubble(
                                        message, isMyMessage);
                                  },
                                ),
                    ),
                    _buildMessageInput(chatProvider, authUserId!, receiverId),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Messages message, bool isMyMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Align(
        alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: isMyMessage ? AppTheme.fMainColor : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isMyMessage
                  ? const Radius.circular(18)
                  : const Radius.circular(0),
              bottomRight: isMyMessage
                  ? const Radius.circular(0)
                  : const Radius.circular(18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isMyMessage ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                calculateTimeForChatMessage(message.createdAt.toString()),
                style: TextStyle(
                  color: isMyMessage ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(
      ChattingProvider chatProvider, String authUserId, String reevicerId) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppTheme.fdarkBlue : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type Something...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconGradientButton(
            width: 50,
            height: 45,
            icon: IconlyBold.send,
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                chatProvider.sendMessage(
                    widget.conversation.id, text, authUserId, reevicerId);
                _messageController.clear();
                // Scroll to bottom after sending
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                chatProvider.fetchConversations();
              }
            },
          ),
        ],
      ),
    );
  }
}
