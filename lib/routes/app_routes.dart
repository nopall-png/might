import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/auth/login_page.dart';
import 'package:wmp/presentation/pages/auth/register_page.dart';
import 'package:wmp/presentation/pages/chat/chat_list_page.dart';
import 'package:wmp/presentation/pages/chat/chat_room_page.dart';
import 'package:wmp/presentation/pages/chat/chats_page.dart';
import 'package:wmp/presentation/pages/profile/edit_profile_page.dart';
import 'package:wmp/presentation/pages/settings/settings_page.dart';
import 'package:wmp/presentation/pages/news/whats_new_page.dart';
// import removed: MatchingFightPage now represented by a popup dialog

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const matches = '/matches';
  static const chats = '/chats';
  static const chatRoom = '/chat-room';
  static const editProfile = '/edit-profile';
  static const settings = '/settings';
  static const whatsNew = '/whats-new';
  // matchingFight page removed; the UI is now a popup

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterScreen(),
    matches: (_) => const ChatListPage(),
    chats: (_) => const ChatsPage(),
    chatRoom: (_) => const ChatRoomPage(),
    editProfile: (_) => const EditProfilePage(),
    settings: (_) => const SettingsPage(),
    whatsNew: (_) => const WhatsNewPage(),
  };
}
