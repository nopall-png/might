import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example collections
  CollectionReference<Map<String, dynamic>> get users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get matches => _db.collection('matches');
  CollectionReference<Map<String, dynamic>> get chats => _db.collection('chats');

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await users.doc(uid).get();
    return doc.data();
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).update(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserMatches(String uid) {
    return matches.where('userIds', arrayContains: uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChatMessages(String roomId) {
    return chats.doc(roomId).collection('messages').orderBy('createdAt').snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> createMatch({
    required List<String> userIds,
    String? opponentName,
    String? createdBy,
    Map<String, dynamic>? extra,
  }) async {
    // compute stable roomId from two userIds
    final parts = [...userIds]..sort();
    final roomId = '${parts.first}_${parts.last}';

    final data = {
      'userIds': userIds,
      'opponentName': opponentName,
      'createdBy': createdBy,
      'status': 'pending',
      'roomId': roomId,
      'createdAt': FieldValue.serverTimestamp(),
      if (extra != null) ...extra,
    };
    return await matches.add(data);
  }

  Future<void> ensureChatRoom(String roomId, {List<String>? userIds}) async {
    await chats.doc(roomId).set({
      if (userIds != null) 'userIds': userIds,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> sendChatMessage(String roomId, Map<String, dynamic> message, {List<String>? userIds}) async {
    // pastikan dokumen chat room ada dan update updatedAt
    await ensureChatRoom(roomId, userIds: userIds);
    await chats.doc(roomId).collection('messages').add(message);
  }

  Future<void> acceptMatch({
    required String matchId,
    required List<String> userIds,
  }) async {
    final parts = [...userIds]..sort();
    final roomId = '${parts.first}_${parts.last}';
    await matches.doc(matchId).update({
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
      'roomId': roomId,
    });
    await ensureChatRoom(roomId, userIds: parts);
  }

  Future<void> declineMatch({
    required String matchId,
    required String declinedBy,
  }) async {
    await matches.doc(matchId).update({
      'status': 'declined',
      'declinedBy': declinedBy,
      'declinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteMatch(String matchId) async {
    await matches.doc(matchId).delete();
  }
}