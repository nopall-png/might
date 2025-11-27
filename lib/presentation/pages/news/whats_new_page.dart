import 'package:flutter/material.dart';
import 'package:wmp/data/services/firestore_service.dart';

class WhatsNewPage extends StatefulWidget {
  const WhatsNewPage({super.key});

  @override
  State<WhatsNewPage> createState() => _WhatsNewPageState();
}

class _WhatsNewPageState extends State<WhatsNewPage> {
  String _query = '';

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            BoxShadow(
                              color: Color(0xFF4C2C82),
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What’s new",
                            style: TextStyle(
                              fontFamily: 'Press Start 2P',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '5 conversations',
                            style: TextStyle(color: Color(0xFFF4EFFF)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7A3FFF),
                      width: 3,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF7A3FFF)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (v) =>
                              setState(() => _query = v.trim().toLowerCase()),
                          decoration: const InputDecoration(
                            hintText: 'Search fighters...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Content list (live from Appwrite)
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirestoreService.instance.streamWhatsNew(
                    onlyActive: true,
                  ),
                  builder: (context, snapshot) {
                    final items =
                        (snapshot.data ??
                                _cards
                                    .map(
                                      (e) => {
                                        'title': e.title,
                                        'subtitle': e.subtitle,
                                        'timeAgo': e.timeAgo,
                                        'bannerUrl': e.bannerAsset,
                                        'avatarUrl': e.avatarAsset,
                                      },
                                    )
                                    .toList())
                            .where((m) {
                              if (_query.isEmpty) return true;
                              final t =
                                  (m['title'] as String?)?.toLowerCase() ?? '';
                              final s =
                                  (m['subtitle'] as String?)?.toLowerCase() ??
                                  '';
                              return t.contains(_query) || s.contains(_query);
                            })
                            .toList();

                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada informasi terbaru',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final m = items[index];
                        final data = _ConversationCardData(
                          title: (m['title'] as String?) ?? 'Unknown',
                          subtitle: (m['subtitle'] as String?) ?? '',
                          timeAgo:
                              _formatAgo(m['createdAt'] as String?) ??
                              (m['timeAgo'] as String? ?? ''),
                          bannerAsset: (m['bannerUrl'] as String?) ?? '',
                          avatarAsset: (m['avatarUrl'] as String?) ?? '',
                        );
                        return _ConversationCard(data: data);
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

  String? _formatAgo(String? iso) {
    if (iso == null) return null;
    final dt = DateTime.tryParse(iso);
    if (dt == null) return null;
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ConversationCardData {
  final String title;
  final String subtitle;
  final String timeAgo;
  final String bannerAsset;
  final String avatarAsset;
  const _ConversationCardData({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.bannerAsset,
    required this.avatarAsset,
  });
}

const _cards = <_ConversationCardData>[];

class _ConversationCard extends StatelessWidget {
  final _ConversationCardData data;
  const _ConversationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6D3CFF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: _imageWidget(
              data.bannerAsset,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar + status dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _imageWidget(
                          data.avatarAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CFF85),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle,
                        style: const TextStyle(
                          color: Color(0xFFF4EFFF),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Time
                Text(
                  data.timeAgo,
                  style: const TextStyle(
                    color: Color(0xFFF4EFFF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget(
    String src, {
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    if (src.startsWith('http')) {
      return Image.network(src, height: height, width: width, fit: fit);
    }
    if (src.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: const Color(0xFF53359A),
      );
    }
    return Image.asset(src, height: height, width: width, fit: fit);
  }
}
