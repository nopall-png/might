import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesNotificationService {
  MatchesNotificationService._();
  static final instance = MatchesNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
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

    _sub = FirestoreService.instance.streamUserMatches(uid).listen((snapshot) {
      for (final change in snapshot.docChanges) {
        final data = change.doc.data() ?? {};
        final opponentName = (data['opponentName'] as String?) ?? (data['opponent'] as String?) ?? 'Unknown';
        final createdBy = data['createdBy'] as String?;
        final status = data['status'] as String?;

        if (change.type == DocumentChangeType.added) {
          // Notify challenged user (not the creator) that a new challenge arrived
          if (createdBy != null && createdBy != uid) {
            _showNotification(title: 'New Challenge', body: 'Challenge from ${opponentName}');
          } else {
            // creator sees "sent" confirmation via UI; optionally notify
            _showNotification(title: 'Challenge Sent', body: 'Waiting for ${opponentName}');
          }
        } else if (change.type == DocumentChangeType.modified) {
          // Notify the creator when the status changes
          if (createdBy == uid && status != null) {
            if (status == 'accepted') {
              _showNotification(title: 'Challenge Accepted', body: '${opponentName} accepted your challenge');
            } else if (status == 'declined') {
              _showNotification(title: 'Challenge Rejected', body: '${opponentName} rejected your challenge');
            }
          }
        }
      }
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
}