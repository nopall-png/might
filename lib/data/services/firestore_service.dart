import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'appwrite_service.dart';
import 'appwrite_config.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Databases get _db => AppwriteService.instance.databases;
  Realtime get _rt => AppwriteService.instance.realtime;

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.profilesCollectionId,
      documentId: uid,
      data: data,
      permissions: [
        Permission.read(Role.user(uid)),
        Permission.write(Role.user(uid)),
      ],
    );
  }

  Future<void> ensureUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      // Create-first: hindari kebutuhan Read pada dokumen/koleksi
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollectionId,
        documentId: uid,
        data: data,
        permissions: [
          Permission.read(Role.user(uid)),
          Permission.write(Role.user(uid)),
        ],
      );
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        // Jika sudah ada, lakukan update
        await _db.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollectionId,
          documentId: uid,
          data: {
            ...data,
            'updatedAt': DateTime.now().toUtc().toIso8601String(),
          },
        );
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.profilesCollectionId,
      documentId: uid,
    );
    return {...doc.data, 'uid': doc.$id};
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.profilesCollectionId,
      documentId: uid,
      data: data,
    );
  }

  Stream<Map<String, dynamic>?> streamUserProfile(String uid) {
    final controller = StreamController<Map<String, dynamic>?>.broadcast();
    () async {
      try {
        final doc = await _db.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollectionId,
          documentId: uid,
        );
        controller.add({...doc.data, 'uid': doc.$id});
      } catch (_) {
        controller.add(null);
      }
    }();
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.profilesCollectionId}.documents.$uid',
    ]);
    sub.stream.listen((event) async {
      try {
        final doc = await _db.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollectionId,
          documentId: uid,
        );
        controller.add({...doc.data, 'uid': doc.$id});
      } catch (_) {
        controller.add(null);
      }
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  Stream<List<Map<String, dynamic>>> streamAllProfiles({String? excludeUid}) {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    () async {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollectionId,
      );
      final list = res.documents
          .where((d) => excludeUid == null || d.$id != excludeUid)
          .map((d) => {...d.data, 'uid': d.$id})
          .toList();
      controller.add(list);
    }();
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.profilesCollectionId}.documents',
    ]);
    sub.stream.listen((event) async {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollectionId,
      );
      final list = res.documents
          .where((d) => excludeUid == null || d.$id != excludeUid)
          .map((d) => {...d.data, 'uid': d.$id})
          .toList();
      controller.add(list);
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  Stream<List<Map<String, dynamic>>> streamUserMatches(String uid) {
    // Emit initial snapshot
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    () async {
      try {
        final res = await _db.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.matchesCollectionId,
          queries: [
            Query.contains('userIds', [uid]),
          ],
        );
        controller.add(
          res.documents.map((d) => {...d.data, 'id': d.$id}).toList(),
        );
      } catch (_) {
        // Jika gagal (izin/permission), tetap emit list kosong agar UI tidak menunggu selamanya
        controller.add(const []);
      }
    }();
    // Subscribe realtime changes
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.matchesCollectionId}.documents',
    ]);
    sub.stream.listen((event) async {
      // Re-query to get consistent list (simpler than diffing)
      try {
        final res = await _db.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.matchesCollectionId,
          queries: [
            Query.contains('userIds', [uid]),
          ],
        );
        controller.add(
          res.documents.map((d) => {...d.data, 'id': d.$id}).toList(),
        );
      } catch (_) {
        controller.add(const []);
      }
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  Stream<List<Map<String, dynamic>>> streamChatMessages(String roomId) {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    () async {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollectionId,
        queries: [Query.equal('roomId', roomId), Query.orderAsc('createdAt')],
      );
      controller.add(res.documents.map((d) => d.data).toList());
    }();
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.messagesCollectionId}.documents',
    ]);
    sub.stream.listen((event) async {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollectionId,
        queries: [Query.equal('roomId', roomId), Query.orderAsc('createdAt')],
      );
      controller.add(res.documents.map((d) => d.data).toList());
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  // Daftar chat rooms milik user (seperti WhatsApp list)
  Stream<List<Map<String, dynamic>>> streamUserChats(String uid) {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    () async {
      try {
        final res = await _db.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatsCollectionId,
          queries: [
            Query.contains('userIds', [uid]),
            Query.orderDesc('updatedAt'),
          ],
        );
        controller.add(
          res.documents.map((d) => {...d.data, 'id': d.$id}).toList(),
        );
      } catch (_) {
        controller.add(const []);
      }
    }();
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.chatsCollectionId}.documents',
    ]);
    sub.stream.listen((event) async {
      try {
        final res = await _db.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatsCollectionId,
          queries: [
            Query.contains('userIds', [uid]),
            Query.orderDesc('updatedAt'),
          ],
        );
        controller.add(
          res.documents.map((d) => {...d.data, 'id': d.$id}).toList(),
        );
      } catch (_) {
        controller.add(const []);
      }
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  // ==========================
  // WHAT'S NEW (admin posts)
  // ==========================
  Stream<List<Map<String, dynamic>>> streamWhatsNew({bool onlyActive = true}) {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    () async {
      controller.add(await _safeListWhatsNew(onlyActive: onlyActive));
    }();
    final sub = _rt.subscribe([
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.whatsNewCollectionId}.documents',
    ]);
    sub.stream.listen((event) async {
      controller.add(await _safeListWhatsNew(onlyActive: onlyActive));
    });
    controller.onCancel = () => sub.close();
    return controller.stream;
  }

  Future<List<Map<String, dynamic>>> _safeListWhatsNew({
    required bool onlyActive,
  }) async {
    // Coba dengan filter & sort yang diinginkan (membutuhkan index).
    final queries = <String>[];
    if (onlyActive) queries.add(Query.equal('isActive', true));
    queries.addAll([Query.orderAsc('sortOrder'), Query.orderDesc('createdAt')]);
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.whatsNewCollectionId,
        queries: queries,
      );
      return res.documents.map((d) => {...d.data, 'id': d.$id}).toList();
    } on AppwriteException catch (_) {
      // Fallback: tanpa query (tidak perlu index). Filter di sisi klien.
      try {
        final res = await _db.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.whatsNewCollectionId,
        );
        final list = res.documents
            .map((d) => {...d.data, 'id': d.$id})
            .toList();
        if (onlyActive) {
          return list.where((m) => (m['isActive'] == true)).toList();
        }
        return list;
      } catch (_) {
        return const [];
      }
    } catch (_) {
      return const [];
    }
  }

  Future<String> createWhatsNewItem({
    required String title,
    String? subtitle,
    String? bannerUrl,
    String? avatarUrl,
    int sortOrder = 100,
    bool isActive = true,
    Map<String, dynamic>? extra,
  }) async {
    final data = {
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      if (extra != null) ...extra,
    };
    final doc = await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.whatsNewCollectionId,
      documentId: ID.unique(),
      data: data,
      // Default: semua user bisa read; write diset ke users untuk memudahkan pengujian.
      // Di produksi, ubah ke Role.user(<ADMIN_UID>) agar hanya admin yang bisa menulis.
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    return doc.$id;
  }

  // Backfill: pastikan dokumen 'chats' ada untuk semua match user
  Future<void> backfillChatsForUser(String uid) async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollectionId,
        queries: [
          Query.contains('userIds', [uid]),
        ],
      );
      for (final d in res.documents) {
        final data = d.data;
        // Hanya buat/selaraskan room chat untuk match yang sudah diterima
        final status = (data['status'] as String?) ?? 'pending';
        if (status != 'accepted') {
          continue;
        }
        final userIds = (data['userIds'] is List)
            ? List<String>.from(data['userIds'])
            : const <String>[];
        String? roomId = data['roomId'] as String?;
        if (roomId == null && userIds.length == 2) {
          final parts = [...userIds]..sort();
          roomId = '${parts.first}_${parts.last}';
        }
        if (roomId == null) continue;
        await ensureChatRoom(
          roomId,
          userIds: userIds.isNotEmpty ? userIds : null,
        );

        // Optional: ambil pesan terakhir untuk mengisi ringkasan jika belum ada
        try {
          final msgs = await _db.listDocuments(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.messagesCollectionId,
            queries: [
              Query.equal('roomId', roomId),
              Query.orderDesc('createdAt'),
              Query.limit(1),
            ],
          );
          if (msgs.documents.isNotEmpty) {
            final m = msgs.documents.first.data;
            final chatDocs = await _db.listDocuments(
              databaseId: AppwriteConfig.databaseId,
              collectionId: AppwriteConfig.chatsCollectionId,
              queries: [Query.equal('roomId', roomId)],
            );
            if (chatDocs.documents.isNotEmpty) {
              await _db.updateDocument(
                databaseId: AppwriteConfig.databaseId,
                collectionId: AppwriteConfig.chatsCollectionId,
                documentId: chatDocs.documents.first.$id,
                data: {
                  'lastMessageText': m['text'],
                  'lastMessageSenderId': m['senderId'],
                  'lastMessageAt':
                      m['createdAt'] ??
                      DateTime.now().toUtc().toIso8601String(),
                  'updatedAt': DateTime.now().toUtc().toIso8601String(),
                },
              );
            }
          }
        } catch (_) {
          // Abaikan jika gagal ambil pesan terakhir
        }
      }
    } catch (_) {
      // Abaikan kegagalan backfill; UI tetap jalan dengan stream kosong
    }
  }

  Future<String> createMatch({
    required List<String> userIds,
    String? opponentName,
    String? createdBy,
    Map<String, dynamic>? extra,
  }) async {
    final parts = [...userIds]..sort();
    final roomId = '${parts.first}_${parts.last}';
    final data = {
      'userIds': userIds,
      'opponentName': opponentName,
      'createdBy': createdBy,
      'status': 'pending',
      'roomId': roomId,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      if (extra != null) ...extra,
    };
    final doc = await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.matchesCollectionId,
      documentId: ID.unique(),
      data: data,
      // Client user hanya boleh menetapkan permission untuk dirinya sendiri atau 'users'.
      // Agar kedua pihak dapat membaca & memperbarui status match, gunakan 'users'.
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );
    return doc.$id;
  }

  Future<void> ensureChatRoom(String roomId, {List<String>? userIds}) async {
    // Upsert berdasarkan field 'roomId', bukan menggunakan documentId = roomId.
    // Alasan: Appwrite membatasi panjang documentId <= 36 char; gabungan dua UID bisa > 36.
    final now = DateTime.now().toUtc().toIso8601String();
    final data = {
      if (userIds != null) 'userIds': userIds,
      'roomId': roomId,
      'updatedAt': now,
    };
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatsCollectionId,
        queries: [Query.equal('roomId', roomId)],
      );
      if (res.documents.isNotEmpty) {
        final docId = res.documents.first.$id;
        await _db.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatsCollectionId,
          documentId: docId,
          data: data,
        );
        return;
      }
      // Tidak ditemukan: buat dokumen baru
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatsCollectionId,
        documentId: ID.unique(),
        data: {'roomId': roomId, ...data},
        permissions: [
          Permission.read(Role.users()),
          Permission.write(Role.users()),
        ],
      );
    } catch (_) {
      // Fallback saat index 'roomId' belum siap: tetap coba create tanpa list terlebih dulu
      try {
        await _db.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatsCollectionId,
          documentId: ID.unique(),
          data: {'roomId': roomId, ...data},
          permissions: [
            Permission.read(Role.users()),
            Permission.write(Role.users()),
          ],
        );
      } catch (_) {
        // Abaikan jika tetap gagal agar UX tidak terblokir
      }
    }
  }

  // Tandai room telah dibaca oleh user tertentu
  Future<void> markRoomRead(String roomId, String uid) async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatsCollectionId,
        queries: [Query.equal('roomId', roomId)],
      );
      if (res.documents.isEmpty) return;
      final doc = res.documents.first;
      final existing =
          (doc.data['readAtMap'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          <String, String>{};
      final now = DateTime.now().toUtc().toIso8601String();
      final updated = {...existing, uid: now};
      await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatsCollectionId,
        documentId: doc.$id,
        data: {'readAtMap': updated},
      );
    } catch (_) {
      // Abaikan kegagalan penandaan read untuk mencegah hambatan UX
    }
  }

  Future<void> sendChatMessage(
    String roomId,
    Map<String, dynamic> message, {
    List<String>? userIds,
  }) async {
    await ensureChatRoom(roomId, userIds: userIds);
    final data = {
      ...message,
      'roomId': roomId,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.messagesCollectionId,
      documentId: ID.unique(),
      data: data,
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users()),
      ],
    );

    // Update chat summary (last message + updatedAt) untuk daftar percakapan
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatsCollectionId,
        queries: [Query.equal('roomId', roomId)],
      );
      if (res.documents.isNotEmpty) {
        final docId = res.documents.first.$id;
        await _db.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatsCollectionId,
          documentId: docId,
          data: {
            'lastMessageText': message['text'],
            'lastMessageSenderId': message['senderId'],
            'lastMessageAt': data['createdAt'],
            'updatedAt': data['createdAt'],
          },
        );
      }
    } catch (_) {
      // Abaikan jika gagal update ringkasan (misal izin); pesan tetap terkirim
    }
  }

  Future<void> acceptMatch({
    required String matchId,
    required List<String> userIds,
  }) async {
    final parts = [...userIds]..sort();
    final roomId = '${parts.first}_${parts.last}';
    await _db.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.matchesCollectionId,
      documentId: matchId,
      data: {
        'status': 'accepted',
        'acceptedAt': DateTime.now().toUtc().toIso8601String(),
        'roomId': roomId,
      },
    );
    await ensureChatRoom(roomId, userIds: parts);
  }

  Future<void> declineMatch({
    required String matchId,
    required String declinedBy,
  }) async {
    await _db.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.matchesCollectionId,
      documentId: matchId,
      data: {
        'status': 'declined',
        'declinedBy': declinedBy,
        'declinedAt': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  Future<void> deleteMatch(String matchId) async {
    await _db.deleteDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.matchesCollectionId,
      documentId: matchId,
    );
  }
}
