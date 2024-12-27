import 'dart:convert';
import 'package:e_commerce/models/chat/conversation.dart';
import 'package:e_commerce/models/chat/messages.dart';
import 'package:e_commerce/services/chatting/chatting_service.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChattingProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  Conversation? _conversation;
  Conversation? get conversation => _conversation;
  String? errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isConversationFetchingLoading = false;
  get isConversationFetchingLoading => _isConversationFetchingLoading;

  IO.Socket? _socket;

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;

  List<Messages> _messages = [];
  List<Messages> get messages => _messages;

  bool _isSocketInitialized =
      false; // Add a flag to track socket initialization
  bool get isSocketInitialized => _isSocketInitialized;

  void initializeSocket(String userId) {
    if (_isSocketInitialized) {
      return; // Socket is already initialized, don't reinitialize
    }

    _socket = IO.io(
      Constants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'userId': userId}) // Send userId as header
          .build(),
    );

    _socket?.connect();

    // Handle connection
    _socket?.onConnect((_) {
      print("Connected to the socket server");
      _socket?.emit("addUser", userId); // Notify server of the connected user
    });

    // Listen for incoming messages
    _socket?.on("getMessage", (data) {
      final newMessage = Messages(
        id: UniqueKey().toString(),
        conversationId: "",
        senderId: data['senderId'],
        text: data['text'],
        createdAt: DateTime.now(),
      );
      _messages.add(newMessage);
      fetchConversations();
      notifyListeners();
    });

    // Handle disconnection
    _socket?.onDisconnect((_) {
      print("Disconnected from socket server");
    });

    // Mark the socket as initialized
    _isSocketInitialized = true;
  }

  // Start a conversation by calling the API and initializing the socket
  Future<int> startConversation(String receiverId, String authUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _chatService.createConversation(receiverId);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['success'] == true) {
          _conversation = Conversation.fromJson(responseData['data'][0]);
        } else {
          errorMessage = responseData['message'];
          notifyListeners();
        }
      } else if (response.statusCode == 400) {
        errorMessage =
            "You are already registered for a conversation with this user.";
        notifyListeners();
      } else {
        errorMessage =
            "Failed to create conversation. Status code: ${response.statusCode}";
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      errorMessage = "An error occurred: $e";
      notifyListeners();
      return 500;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String conversationId, String text, String senderId,
      String receriverId) async {
    final responseMessage =
        await _chatService.sendMessage(conversationId, text);

    if (responseMessage != null) {
      _messages.add(responseMessage);
      notifyListeners();

      _socket?.emit("sendMessage", {
        "senderId": senderId, // Replace with actual senderId
        "receiverId": receriverId, // Use receiverId based on conversation
        "text": text,
      });
    } else {
      errorMessage = "Failed to send message.";
      notifyListeners();
    }
  }

  Future<void> loadMessages(String conversationId) async {
    _isLoading = true;
    notifyListeners();
    List<Messages> loadedMessages =
        await _chatService.getMessagesByConversationId(conversationId);

    _messages = loadedMessages;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchConversations() async {
    _isConversationFetchingLoading = true;
    notifyListeners();

    try {
      _conversations = await _chatService.getAllConversations();
      print(_conversations.length);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to load conversations: $e';
      notifyListeners();
    } finally {
      _isConversationFetchingLoading = false;
    }
  }

  void disconnectSocket() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket!.off("getMessage");
    }
    _isSocketInitialized = false;
    notifyListeners();
  }
}
