class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime time;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
