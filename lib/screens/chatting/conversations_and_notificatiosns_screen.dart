import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/models/chat/conversation.dart';
import 'package:ajar/providers/chatting/chatting_provider.dart';
import 'package:ajar/screens/chatting_and_notifications/chat_screen.dart';
import 'package:ajar/screens/chatting_and_notifications/message_item_shimmer.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:carded/carded.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ConverationsScreen extends StatefulWidget {
  const ConverationsScreen({super.key});

  @override
  State<ConverationsScreen> createState() => _ConverationsScreenState();
}

class _ConverationsScreenState extends State<ConverationsScreen> {
  @override
  void initState() {
    // Fetch vehicles when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChattingProvider>(context, listen: false)
          .fetchConversations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Inbox",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: isDarkMode ? Colors.white : fMainColor,
                      unselectedLabelColor:
                          isDarkMode ? Colors.grey : Colors.grey,
                      indicatorColor: isDarkMode ? Colors.white : fMainColor,
                      tabs: const [
                        Tab(text: "Messages"),
                        Tab(text: "Notifications"),
                      ],
                    ),
                    Expanded(
                      child: Consumer<ChattingProvider>(
                        builder: (context, chattingProvider, _) {
                          if (chattingProvider.isConversationFetchingLoading) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: MessageItemShimmer(),
                                );
                              },
                            );
                          }
                          return TabBarView(
                            children: [
                              // My Bookings Tab
                              chattingProvider.conversations.isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount:
                                          chattingProvider.conversations.length,
                                      itemBuilder: (context, index) {
                                        final conversation = chattingProvider
                                            .conversations[index];
                                        return _buildMessageItem(
                                          conversation: conversation,
                                          name:
                                              "${conversation.otherUser!.firstName} ${conversation.otherUser!.lastName}",
                                          message:
                                              conversation.messages!.isEmpty
                                                  ? " "
                                                  : conversation
                                                      .messages!.last.text,
                                          date: conversation.messages!.isEmpty
                                              ? " "
                                              : formatDateWithTime(
                                                  conversation
                                                      .messages!.last.createdAt
                                                      .toString(),
                                                ),
                                          time: conversation.messages!.isEmpty
                                              ? " "
                                              : getFormattedTime12Hour(
                                                  conversation
                                                      .messages!.last.createdAt
                                                      .toString(),
                                                ),
                                          avatarColor: fMainColor,
                                          avatarUrl: conversation
                                                  .otherUser!.profilePicture ??
                                              'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                                        );
                                      },
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [Text("No message yet!")],
                                      ),
                                    ),

                              _buildNotificationsView(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notifications tab content
  Widget _buildNotificationsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationItem(
          name: "Listing Published Successfully!",
          message: "Your car is now live on Ajar. Get ready to host!",
          time: "Just Now",
          avatarColor: fMainColor,
        ),
        const SizedBox(height: 16),
        _buildNotificationItem(
          name: "New Rental Request!",
          message:
              "You have a booking request for your car. Review and confirm now!",
          time: "10 Minutes Ago",
          avatarColor: fMainColor,
        ),
        const SizedBox(height: 16),
        _buildNotificationItem(
          name: "Booking Cancelled!",
          message:
              "The renter has cancelled their booking. Your car is now available again.",
          time: "1 Hour Ago",
          avatarColor: fMainColor,
        ),
      ],
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
        message.length > 40 ? "${message.substring(0, 40)}..." : message;

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
        color: isDarkMode ? fdarkBlue : Colors.white,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.only(bottom: 16),
        spreadRadius: 0,
        blurRadius: 1,
        shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
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
                    const SizedBox(height: 4),
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

  // Notification item layout
  Widget _buildNotificationItem({
    required String name,
    required String message,
    required String time,
    required Color avatarColor,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CardyContainer(
      color: isDarkMode ? fdarkBlue : Colors.white,
      borderRadius: BorderRadius.circular(10),
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
                backgroundColor: avatarColor,
                radius: 24,
                child: const Icon(
                  IconlyLight.notification,
                  color: Colors.white,
                )),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
