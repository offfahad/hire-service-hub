import 'package:e_commerce/models/auth/user_model.dart';
import 'package:e_commerce/models/chat/messages.dart';

class Conversation {
  String id;
  List<String> members;
  DateTime createdAt;
  List<Messages>? messages;
  UserModel? otherUser;

  Conversation({
    required this.id,
    required this.members,
    required this.createdAt,
    this.otherUser,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        members: List<String>.from(json["members"].map((x) => x)),
        createdAt: DateTime.parse(json["timestamp"]),
      );

  factory Conversation.fromJsonGetConversations(Map<String, dynamic> json) =>
      Conversation(
        id: json["id"],
        members: List<String>.from(json["members"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        otherUser: UserModel.fromJsonForLogin(json["otherUser"]),
        messages: List<Messages>.from(
            json["messages"].map((x) => Messages.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "members": List<dynamic>.from(members.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
      };
}
