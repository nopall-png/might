import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wmp/data/services/firestore_service.dart';

class ChatNotificationService {
  ChatNotificationService._();
  static final instance = ChatNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  final Map<String, Map<String, dynamic>> _last = {};
  bool _initialized = false;
  bool _hasInitial = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      'chats_channel',
      'Chats Notifications',
      description: 'Notifikasi untuk pesan chat baru',
      importance: Importance.high,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      await androidPlugin.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> startListening(String uid) async {
    await initialize();
    await _sub?.cancel();
    _hasInitial = false;

    _sub = FirestoreService.instance.streamUserChats(uid).listen((items) async {
      // Bangun peta dokumen saat ini
      final current = <String, Map<String, dynamic>>{};
      for (final data in items) {
        final id = (data['id'] as String?) ?? '';
        if (id.isEmpty) continue;
        current[id] = data;

        final lastAtStr = data['lastMessageAt'] as String?;
        final lastSender = data['lastMessageSenderId'] as String?;
        final text = (data['lastMessageText'] as String?) ?? '';
        final roomId = data['roomId'] as String?;
        final userIds = (data['userIds'] is List)
            ? List<String>.from(data['userIds'])
            : <String>[];
        final readMapRaw = data['readAtMap'];
        final readMap = (readMapRaw is Map)
            ? readMapRaw.map((k, v) => MapEntry(k.toString(), v.toString()))
            : <String, String>{};

        if (lastSender == null || lastSender == uid) {
          // Jangan notifikasi pesan dari diri sendiri / belum ada pesan
          continue;
        }

        if (lastAtStr == null || lastAtStr.trim().isEmpty) {
          continue;
        }

        final lastAt = DateTime.tryParse(lastAtStr);
        final readAt = readMap[uid] != null ? DateTime.tryParse(readMap[uid]!) : null;

        // Lewati emisi pertama untuk menghindari notifikasi massal saat bootstrap
        if (!_hasInitial) {
          continue;
        }

        // Deteksi perubahan lastMessageAt dibanding snapshot sebelumnya
        final prev = _last[id];
        final prevLastAtStr = prev != null ? prev['lastMessageAt'] as String? : null;
        final prevLastAt = prevLastAtStr != null ? DateTime.tryParse(prevLastAtStr) : null;
        final changed = (prevLastAt == null && lastAt != null) ||
            (prevLastAt != null && lastAt != null && lastAt.isAfter(prevLastAt));

        final isUnread = lastAt != null && (readAt == null || lastAt.isAfter(readAt));

        if (changed && isUnread) {
          final name = await _resolvePeerName(uid: uid, userIds: userIds, roomId: roomId);
          final safeText = text.isNotEmpty ? text : 'Pesan baru';
          await _showNotification(
            title: 'Pesan baru dari $name',
            body: safeText,
          );
        }
      }

      // Update cache
      _last
        ..clear()
        ..addAll(current);

      // Tandai bahwa initial snapshot sudah lewat
      _hasInitial = true;
    });
  }

  Future<void> stopListening() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _showNotification({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'chats_channel',
        'Chats Notifications',
        channelDescription: 'Notifikasi untuk pesan chat baru',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _notifications.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, details);
  }

  Future<String> _resolvePeerName({required String uid, required List<String> userIds, String? roomId}) async {
    try {
      String? peerUid;
      if (userIds.isNotEmpty) {
        for (final id in userIds) {
          if (id != uid) {
            peerUid = id;
            break;
          }
        }
      }
      if (peerUid == null && roomId != null) {
        final parts = roomId.split('_');
        if (parts.length == 2) {
          final a = parts[0];
          final b = parts[1];
          peerUid = a == uid ? b : a;
        }
      }
      if (peerUid != null) {
        final profile = await FirestoreService.instance.getUserProfile(peerUid);
        final name = (profile?['displayName'] as String?) ??
            (profile?['name'] as String?) ??
            (profile?['username'] as String?);
        if (name != null && name.trim().isNotEmpty) {
          return name;
        }
      }
    } catch (_) {
      // ignore errors
    }
    return 'Lawannya';
  }
}

