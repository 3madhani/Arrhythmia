class ChatRoom {
  String? id;
  List? members;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;

  ChatRoom({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        id: json['id'] ?? "",
        members: json['members'] ?? "",
        lastMessage: json['last_message'] ?? "",
        lastMessageTime: json['last_message_time'] ?? "",
        createdAt: json['created_at'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'members': members,
        'last_message': lastMessage,
        'last_message_time': lastMessageTime,
        'created_at': createdAt,
      };
}
