import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wmp/data/services/firestore_service.dart';

class MatchesNotificationService {
  MatchesNotificationService._();
  static final instance = MatchesNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  final Map<String, Map<String, dynamic>> _last = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);

    // Create channel for Android
    const channel = AndroidNotificationChannel(
      'matches_channel',
      'Matches Notifications',
      description: 'Notify when a new match is created',
      importance: Importance.high,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      // Android 13+ runtime permission
      await androidPlugin.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> startListening(String uid) async {
    await initialize();
    await _sub?.cancel();

    _sub = FirestoreService.instance.streamUserMatches(uid).listen((items) {
      // Build map by id for diffing
      final current = <String, Map<String, dynamic>>{};
      for (final data in items) {
        final id = (data['id'] as String?) ?? '';
        if (id.isEmpty) continue;
        current[id] = data;
        final createdBy = data['createdBy'] as String?;
        final status = data['status'] as String?;

        if (!_last.containsKey(id)) {
          // Added
          _resolveDisplayName(data, uid).then((name) {
            if (createdBy != null && createdBy != uid) {
              _showNotification(title: 'New Challenge', body: 'Challenge from $name');
            } else {
              _showNotification(title: 'Challenge Sent', body: 'Waiting for $name');
            }
          });
        } else {
          // Modified
          final prev = _last[id]!;
          final prevStatus = prev['status'] as String?;
          if (createdBy == uid && status != null && status != prevStatus) {
            _resolveDisplayName(data, uid).then((name) {
              if (status == 'accepted') {
                _showNotification(title: 'Challenge Accepted', body: '$name accepted your challenge');
              } else if (status == 'declined') {
                _showNotification(title: 'Challenge Rejected', body: '$name rejected your challenge');
              }
            });
          }
        }
      }
      _last
        ..clear()
        ..addAll(current);
    });
  }

  Future<void> stopListening() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _showNotification({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'matches_channel',
        'Matches Notifications',
        channelDescription: 'Notify when a new match is created',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _notifications.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, details);
  }

  // Resolve display name based on who sent the challenge and match participants
  Future<String> _resolveDisplayName(Map<String, dynamic> data, String myUid) async {
    try {
      final createdBy = data['createdBy'] as String?;
      final userIds = (data['userIds'] as List?)?.whereType<String>().toList() ?? const <String>[];

      String? targetUid;
      if (createdBy != null && createdBy != myUid) {
        // We received a challenge: show sender's name
        targetUid = createdBy;
      } else {
        // We sent a challenge: show opponent's name (the other participant)
        for (final id in userIds) {
          if (id != myUid) {
            targetUid = id;
            break;
          }
        }
      }

      if (targetUid != null) {
        final profile = await FirestoreService.instance.getUserProfile(targetUid);
        final name = (profile?['displayName'] as String?) ??
            (profile?['name'] as String?) ??
            (profile?['username'] as String?);
        if (name != null && name.trim().isNotEmpty) {
          return name;
        }
      }
    } catch (_) {
      // ignore errors and fall back
    }
    // Fall back to what exists in match doc
    return (data['opponentName'] as String?) ?? (data['opponent'] as String?) ?? 'Unknown';
  }
}
