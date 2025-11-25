import 'chat_item.dart';

/// Shared dummy chat items used by Home badge and ChatListPage
final List<ChatItem> chatItems = [
  ChatItem(
    name: 'Alex "Thunder"',
    style: 'Muay Thai',
    lastMessage: 'See you at the gym tomorrow! 🥊',
    timeAgo: '2m ago',
    avatarAsset: 'assets/images/dummyimage.jpg',
    unread: 2,
    online: true,
  ),
  ChatItem(
    name: 'Jordan "Viper"',
    style: 'BJJ',
    lastMessage: 'Great session today! Thanks',
    timeAgo: '1h ago',
    avatarAsset: 'assets/images/dummyimage2.jpg',
    online: true,
  ),
  ChatItem(
    name: 'Sam "Dragon"',
    style: 'Boxing',
    lastMessage: 'When are you free this week?',
    timeAgo: '3h ago',
    avatarAsset: 'assets/images/dummyimage.jpg',
    unread: 1,
  ),
  ChatItem(
    name: 'Taylor "Phoenix"',
    style: 'Kickboxing',
    lastMessage: "Let's schedule a sparring match",
    timeAgo: '1d ago',
    avatarAsset: 'assets/images/dummyimage2.jpg',
  ),
  ChatItem(
    name: 'Casey "Phantom"',
    style: 'Karate',
    lastMessage: 'Thanks for the tips!',
    timeAgo: '2d ago',
    avatarAsset: 'assets/images/dummyimage.jpg',
  ),
];