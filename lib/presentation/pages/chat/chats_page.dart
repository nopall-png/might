import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/routes/app_routes.dart';
import 'package:wmp/presentation/widgets/responsive_app_bar.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool _backfilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = AuthService.instance.currentUser?.uid;
    if (!_backfilled && uid != null) {
      _backfilled = true;
      // Jalankan backfill sekali saat halaman dibuka
      FirestoreService.instance.backfillChatsForUser(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUid = AuthService.instance.currentUser?.uid;
    return Scaffold(
      extendBody: true,
      appBar: ResponsiveGradientAppBar(
        title: 'Chats',
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B164A), Color(0xFF7A3FFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: myUid == null
                      ? const Center(
                          child: Text(
                            'Silakan login untuk melihat chat',
                            style: TextStyle(color: Colors.black87),
                          ),
                        )
                      : StreamBuilder<List<Map<String, dynamic>>>(
                          stream: FirestoreService.instance.streamUserChats(
                            myUid,
                          ),
                          builder: (context, snapshot) {
                            final chats = snapshot.data ?? const [];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.deepPurpleAccent,
                                ),
                              );
                            }
                            if (chats.isEmpty) {
                              return _emptyState();
                            }
                            return ListView.separated(
                              itemCount: chats.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                color: Color(0xFFDDCFF6),
                              ),
                              itemBuilder: (context, index) {
                                final chat = chats[index];
                                return _chatTile(context, myUid, chat);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/msg.svg',
            color: const Color(0xFF7A3FFF),
            width: 36,
            height: 36,
          ),
          const SizedBox(height: 10),
          const Text(
            'Belum ada percakapan',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _chatTile(
    BuildContext context,
    String myUid,
    Map<String, dynamic> chat,
  ) {
    final roomId =
        (chat['roomId'] as String?) ?? _deriveRoomId(chat['userIds']);
    final userIds = (chat['userIds'] is List)
        ? List<String>.from(chat['userIds'])
        : const <String>[];
    final peerUid =
        _peerFromUserIds(userIds, myUid) ?? _peerFromRoomId(roomId, myUid);
    final lastText =
        (chat['lastMessageText'] as String?) ?? 'Tap untuk membuka chat';
    final lastAtStr = chat['lastMessageAt'] as String?;
    final lastAt = lastAtStr != null
        ? DateTime.tryParse(lastAtStr)?.toLocal()
        : null;
    final timeLabel = lastAt != null ? _formatTime(lastAt) : '';
    final readMap = (chat['readAtMap'] is Map)
        ? Map<String, dynamic>.from(chat['readAtMap'])
        : const <String, dynamic>{};
    final myReadStr = readMap[myUid] as String?;
    final myReadAt = myReadStr != null
        ? DateTime.tryParse(myReadStr)?.toLocal()
        : null;
    final lastSenderId = chat['lastMessageSenderId'] as String?;
    final hasUnread =
        lastAt != null &&
        lastSenderId != null &&
        lastSenderId != myUid &&
        (myReadAt == null || lastAt.isAfter(myReadAt));

    return FutureBuilder<Map<String, dynamic>?>(
      future: peerUid != null
          ? FirestoreService.instance.getUserProfile(peerUid)
          : Future.value(null),
      builder: (context, snap) {
        final profile = snap.data;
        final displayName = profile?['displayName'] as String? ?? 'Unknown';
        final photoUrl =
            (profile?['photoUrl'] ?? profile?['imagePath']) as String?;
        final isNetwork = photoUrl != null && photoUrl.startsWith('http');

        return ListTile(
          onTap: () {
            if (roomId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Room tidak ditemukan')),
              );
              return;
            }
            Navigator.pushNamed(
              context,
              AppRoutes.chatRoom,
              arguments: {'roomId': roomId, 'peerName': displayName},
            );
          },
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFA96CFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isNetwork
                  ? Image.network(
                      photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/images/dummyimage.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/dummyimage.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(
            displayName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B164A),
            ),
          ),
          subtitle: Text(
            lastText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF7A3FFF)),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeLabel,
                style: const TextStyle(color: Color(0xFF7A3FFF), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chevron_right, color: Color(0xFF7A3FFF)),
                  if (hasUnread) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5CFF85),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String? _deriveRoomId(dynamic userIds) {
    if (userIds is List && userIds.length == 2) {
      final parts = List<String>.from(userIds)..sort();
      return '${parts.first}_${parts.last}';
    }
    return null;
  }

  String? _peerFromUserIds(List<String> userIds, String myUid) {
    if (userIds.isEmpty) return null;
    if (userIds.length == 1)
      return userIds.first == myUid ? null : userIds.first;
    return userIds.first == myUid ? userIds.last : userIds.first;
  }

  String? _peerFromRoomId(String? roomId, String myUid) {
    if (roomId == null) return null;
    final parts = roomId.split('_');
    if (parts.length != 2) return null;
    return parts.first == myUid ? parts.last : parts.first;
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final isToday =
        t.year == now.year && t.month == now.month && t.day == now.day;
    if (isToday) {
      final hh = t.hour.toString().padLeft(2, '0');
      final mm = t.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}';
  }
}
