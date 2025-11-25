import 'package:flutter/material.dart';

class ChatItem {
  final String name;
  final String style;
  final String lastMessage;
  final String timeAgo;
  final String avatarAsset;
  final int unread;
  final bool online;

  ChatItem({
    required this.name,
    required this.style,
    required this.lastMessage,
    required this.timeAgo,
    required this.avatarAsset,
    this.unread = 0,
    this.online = false,
  });
}