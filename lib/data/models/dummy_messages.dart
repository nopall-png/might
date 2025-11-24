import '../models/message_model.dart';

final dummyMessages = [
  MessageModel(
    id: "1",
    senderId: "alex",
    text: "Hey! Great to match with you! 🥊",
    time: DateTime.parse("2025-11-21 10:30:00"),
    isMe: false,
  ),
  MessageModel(
    id: "2",
    senderId: "me",
    text: "Same here! Looking forward to training together",
    time: DateTime.parse("2025-11-21 10:32:00"),
    isMe: true,
  ),
  MessageModel(
    id: "3",
    senderId: "alex",
    text: "When are you usually free to spar?",
    time: DateTime.parse("2025-11-21 10:33:00"),
    isMe: false,
  ),
  MessageModel(
    id: "4",
    senderId: "me",
    text: "Weekday evenings and Saturday mornings work best for me",
    time: DateTime.parse("2025-11-21 10:35:00"),
    isMe: true,
  ),
  MessageModel(
    id: "5",
    senderId: "alex",
    text: "Perfect! How about this Saturday at 9 AM?",
    time: DateTime.parse("2025-11-21 10:36:00"),
    isMe: false,
  ),
];
