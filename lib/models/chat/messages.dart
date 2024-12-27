class Messages {
  String? id;
  String? conversationId;
  String senderId;
  String text;
  DateTime? createdAt;

  Messages({
    this.id,
    this.conversationId,
    required this.senderId,
    required this.text,
    this.createdAt,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        id: json["id"] ?? '',
        conversationId: json["conversation_id"] ?? '',
        senderId: json["sender_id"] ?? '',
        text: json["text"] ?? '',
        createdAt: DateTime.parse(json["timestamp"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "text": text,
        "created_at": createdAt!.toIso8601String(),
      };  
}
