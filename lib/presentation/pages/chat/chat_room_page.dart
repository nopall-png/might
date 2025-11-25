import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatMessage {
  final String text;
  final DateTime time;
  final bool fromMe;
  _ChatMessage({required this.text, required this.time, required this.fromMe});
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  String? _roomId;
  String? _peerName;
  List<String> _userIds = const [];
  String? _peerUid;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil argumen dari route sekali
    if (_roomId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        _roomId = args['roomId'] as String?;
        _peerName = args['peerName'] as String?;
        // Parse userIds dari roomId (format: uidA_uidB) dan pastikan dokumen chat room ada
        if (_roomId != null) {
          final parts = _roomId!.split('_');
          if (parts.length == 2) {
            _userIds = parts;
            FirestoreService.instance.ensureChatRoom(_roomId!, userIds: _userIds);
            final myUid = AuthService.instance.currentUser?.uid;
            if (myUid != null) {
              final uidA = parts[0];
              final uidB = parts[1];
              _peerUid = uidA == myUid ? uidB : uidA;
            }
          } else {
            // fallback: tetap buat dokumen tanpa userIds agar updatedAt terisi
            FirestoreService.instance.ensureChatRoom(_roomId!);
          }
        }
      }
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _roomId == null) return;
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login untuk mengirim pesan')));
      return;
    }
    try {
      await FirestoreService.instance.sendChatMessage(_roomId!, {
        'text': text,
        'senderId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, userIds: _userIds.isNotEmpty ? _userIds : null);
      _controller.clear();
      // Scroll ke bawah
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA96CFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        (_peerName ?? 'Chat Room'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontFamily: 'Press Start 2P',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        tooltip: 'Options',
                        offset: const Offset(0, 32),
                        color: const Color(0xFF622E9E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        onSelected: (value) {
                          if (value == 'view_profile') {
                            final fighter = Fighter(
                              name: _peerName ?? 'Opponent',
                              age: 20,
                              martialArt: '—',
                              bio: 'Profil lawan',
                              imagePath: 'assets/images/dummyimage.jpg',
                              experience: 'beginner',
                              distance: 0.0,
                              match: '—',
                              weight: '—',
                              height: '—',
                              lastMatch: '—',
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(fighter: fighter, uid: _peerUid),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'view_profile',
                            child: Text('View Profile', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA96CFF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
                            ],
                          ),
                          child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Messages list
              Expanded(
                child: _roomId == null
                    ? const Center(child: Text('Room tidak ditemukan', style: TextStyle(color: Colors.white)))
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirestoreService.instance.streamChatMessages(_roomId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          }
                          final docs = snapshot.data?.docs ?? [];
                          final uid = AuthService.instance.currentUser?.uid;
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data();
                              final text = (data['text'] as String?) ?? '';
                              final senderId = data['senderId'] as String?;
                              final ts = data['createdAt'];
                              DateTime time;
                              if (ts is Timestamp) {
                                time = ts.toDate();
                              } else {
                                time = DateTime.now();
                              }
                              final msg = _ChatMessage(text: text, time: time, fromMe: senderId != null && uid != null && senderId == uid);
                              return _MessageBubble(message: msg);
                            },
                          );
                        },
                      ),
              ),

              // Input bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF622E9E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _send,
                        child: Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA96CFF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/send.svg', color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final align = message.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.fromMe ? const Color(0xFF8B5CF6) : const Color(0xFF4C2C82);
    final shadowColor = const Color(0xFF4C2C82);

    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: message.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(4, 4))],
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.time),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}