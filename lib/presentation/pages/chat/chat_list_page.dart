import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
// Firebase dihapus
import 'package:wmp/routes/app_routes.dart';
import 'package:wmp/presentation/widgets/responsive_app_bar.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService.instance.currentUser?.uid;

    return Scaffold(
      appBar: ResponsiveGradientAppBar(
        title: 'Matches Notification',
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B164A), Color(0xFF7A3FFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA96CFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search fighters...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // List (Firestore-based)
              Expanded(
                child: uid == null
                    ? const Center(
                        child: Text(
                          'Silakan login untuk melihat matches',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : StreamBuilder<List<Map<String, dynamic>>>(
                        stream: FirestoreService.instance.streamUserMatches(
                          uid,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          final items = snapshot.data ?? [];
                          if (items.isEmpty) {
                            return const Center(
                              child: Text(
                                'Belum ada match. Swipe dulu untuk mencari lawan.',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final data = items[index];
                              final matchId =
                                  (data['\$id'] as String?) ??
                                  (data['id'] as String?) ??
                                  'unknown';
                              final userIds =
                                  (data['userIds'] as List?)
                                      ?.whereType<String>()
                                      .toList() ??
                                  [];
                              final peerUid = userIds
                                  .where((id) => id != uid)
                                  .firstOrNull;
                              final opponentName =
                                  (data['opponentName'] as String?) ??
                                  (data['opponent'] as String?);
                              final createdBy = data['createdBy'] as String?;
                              final status =
                                  (data['status'] as String?) ?? 'pending';
                              final ts = data['createdAt'];
                              final createdAt = ts is String
                                  ? DateTime.tryParse(ts) ?? DateTime.now()
                                  : DateTime.now();

                              // Fetch opponent profile (name/style) if not available in match doc
                              return FutureBuilder<Map<String, dynamic>?>(
                                future: peerUid != null
                                    ? FirestoreService.instance.getUserProfile(
                                        peerUid,
                                      )
                                    : Future.value(null),
                                builder: (context, profSnap) {
                                  final profile = profSnap.data;
                                  final name =
                                      opponentName ??
                                      (profile?['displayName'] as String?) ??
                                      'Unknown';
                                  final style =
                                      (profile?['martialArt'] as String?) ??
                                      '-';
                                  final imageUrl =
                                      (profile?['photoUrl'] as String?) ??
                                      (profile?['imagePath'] as String?);
                                  final roomIdDoc = data['roomId'] as String?;
                                  final timeAgo = _formatTimeAgo(createdAt);
                                  return _chatTileFromData(
                                    context,
                                    name: name,
                                    style: style,
                                    timeAgo: timeAgo,
                                    peerUid: peerUid,
                                    matchId: matchId,
                                    status: status,
                                    createdBy: createdBy,
                                    imageUrl: imageUrl,
                                    roomIdDoc: roomIdDoc,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _chatTileFromData(
    BuildContext context, {
    required String name,
    required String style,
    required String timeAgo,
    required String? peerUid,
    required String matchId,
    required String status,
    required String? createdBy,
    String? imageUrl,
    String? roomIdDoc,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final myUid = AuthService.instance.currentUser?.uid;
          if (myUid == null) return;
          // Jika match sudah diterima, buka chat
          if (status == 'accepted') {
            String? roomId;
            List<String>? parts;
            if (peerUid != null) {
              parts = [myUid, peerUid]..sort();
              roomId = '${parts[0]}_${parts[1]}';
            } else {
              roomId = roomIdDoc;
            }
            if (roomId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Room chat tidak ditemukan untuk match ini.'),
                ),
              );
              return;
            }
            Navigator.pushNamed(
              context,
              AppRoutes.chatRoom,
              arguments: {'roomId': roomId, 'peerName': name},
            );
            // Sinkronkan room (aman, tanpa memblokir UI)
            try {
              if (parts != null) {
                // ignore: unawaited_futures
                FirestoreService.instance.ensureChatRoom(roomId!, userIds: parts);
              } else {
                // ignore: unawaited_futures
                FirestoreService.instance.ensureChatRoom(roomId!);
              }
            } catch (_) {}
            return;
          }
          // Jika masih pending/declined: tampilkan profil lawan terlebih dahulu
          if (peerUid != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(
                  fighter: _stubFighter(name: name, imageUrl: imageUrl),
                  uid: peerUid,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil lawan tidak tersedia.'),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF7A3FFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
            ],
          ),
          child: Row(
            children: [
              // Avatar: photoUrl dari database, fallback ke dummy
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                clipBehavior: Clip.antiAlias,
                child: (imageUrl != null && imageUrl.startsWith('http'))
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
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
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Press Start 2P',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Options menu (e.g., delete notification)
                        PopupMenuButton<String>(
                          color: const Color(0xFF7A3FFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) async {
                            if (value == 'delete') {
                              try {
                                await FirestoreService.instance.deleteMatch(
                                  matchId,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notifikasi dihapus'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal menghapus: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Hapus notifikasi',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Style
                    Row(
                      children: [
                        const Text('🥋', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          style,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Actions depending on status
                    Builder(
                      builder: (ctx) {
                        final myUid = AuthService.instance.currentUser?.uid;
                        final isChallengedUser =
                            createdBy != null &&
                            myUid != null &&
                            createdBy != myUid;
                        if (status == 'pending' && isChallengedUser) {
                          return Row(
                            children: [
                              // ACCEPT
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (myUid == null || peerUid == null)
                                      return;
                                    final parts = [myUid, peerUid]..sort();
                                    await FirestoreService.instance.acceptMatch(
                                      matchId: matchId,
                                      userIds: parts,
                                    );
                                    final roomId = '${parts[0]}_${parts[1]}';
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.chatRoom,
                                      arguments: {
                                        'roomId': roomId,
                                        'peerName': name,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF54D66A),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'ACCEPT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Press Start 2P',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // VIEW PROFILE
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (peerUid == null) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfilePage(
                                          fighter: _stubFighter(
                                            name: name,
                                            imageUrl: imageUrl,
                                          ),
                                          uid: peerUid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA96CFF),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'VIEW PROFILE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Press Start 2P',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // DECLINE
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (myUid == null) return;
                                    await FirestoreService.instance
                                        .declineMatch(
                                          matchId: matchId,
                                          declinedBy: myUid,
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Challenge ditolak.'),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B6B),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'DECLINE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Press Start 2P',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        // Non-pending or challenger view: show status with delete option
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                status == 'accepted'
                                    ? 'Tap to chat'
                                    : status == 'declined'
                                    ? 'Challenge rejected'
                                    : 'Waiting for response',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                try {
                                  await FirestoreService.instance.deleteMatch(
                                    matchId,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Notifikasi dihapus'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal menghapus: $e'),
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 36,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA96CFF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stub Fighter untuk tampilan awal ProfilePage; data asli akan di-stream dari uid
  Fighter _stubFighter({required String name, String? imageUrl}) {
    return Fighter(
      name: name,
      age: 20,
      martialArt: '-'
          ,
      bio: '—',
      imagePath: imageUrl ?? 'assets/images/dummyimage.jpg',
      experience: '-',
      distance: 0,
      location: '-',
      match: '-',
      weight: '-',
      height: '-',
      lastMatch: '-',
    );
  }
}
