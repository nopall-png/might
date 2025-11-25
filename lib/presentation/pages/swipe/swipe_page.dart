import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/presentation/pages/widgets/fighter_card.dart';
import 'package:wmp/presentation/pages/match/match_popup.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';

class SwipeController {
  VoidCallback? skip;
  VoidCallback? challenge;
}

class SwipePage extends StatefulWidget {
  const SwipePage({super.key, this.controller});

  final SwipeController? controller;

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  int index = 0;
  double positionX = 0;
  double angle = 0;
  List<Fighter> _fighters = [];
  List<String> _uids = [];
  String? _myUid;

  Fighter _mapProfileToFighter(Map<String, dynamic> data) {
    final name = (data['displayName'] as String?) ?? 'Fighter';
    final ageVal = data['age'];
    final age = ageVal is int ? ageVal : int.tryParse(ageVal?.toString() ?? '') ?? 20;
    final style = (data['martialArt'] as String?) ?? '—';
    final about = (data['about'] as String?) ?? 'Ready to fight and train.';
    final exp = (data['experience'] as String?) ?? 'beginner';
    final weightVal = data['weightKg'];
    final heightVal = data['heightCm'];
    final weightStr = weightVal is int ? '${weightVal} kg' : (weightVal is String && weightVal.isNotEmpty ? '${weightVal} kg' : '—');
    final heightStr = heightVal is int ? '${heightVal} cm' : (heightVal is String && heightVal.isNotEmpty ? '${heightVal} cm' : '—');
    return Fighter(
      name: name,
      age: age,
      martialArt: style,
      bio: about,
      imagePath: 'assets/images/dummyimage.jpg',
      experience: exp,
      distance: 0.0,
      match: '0 matches',
      weight: weightStr,
      height: heightStr,
      lastMatch: '—',
    );
  }

  void _showMatchPopup(fighter) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MatchPopup(
        fighter: fighter,
        opponentUid: _uids.isEmpty ? null : _uids[index % _uids.length],
      ),
    );
  }

  void _nextCard() {
    setState(() {
      index = _fighters.isEmpty ? 0 : (index + 1) % _fighters.length;
      positionX = 0;
      angle = 0;
    });
  }

  void _onSwipeEnd() {
    if (_fighters.isEmpty) {
      setState(() {
        positionX = 0;
        angle = 0;
      });
      return;
    }
    final fighter = _fighters[index % _fighters.length];

    if (positionX > 120) {
      print("CHALLENGE ✅");
      _showMatchPopup(fighter);
      _nextCard();
    } else if (positionX < -120) {
      print("SKIP ❌");
      _nextCard();
    } else {
      setState(() {
        positionX = 0;
        angle = 0;
      });
    }
  }

  void _skip() {
    print("SKIP ❌");
    _nextCard();
  }

  void _challenge() {
    if (_fighters.isEmpty) return;
    final fighter = _fighters[index % _fighters.length];
    print("CHALLENGE ✅");
    _showMatchPopup(fighter);
    _nextCard();
  }

  @override
  void initState() {
    super.initState();
    // Wire controller callbacks if provided
    widget.controller?.skip = _skip;
    widget.controller?.challenge = _challenge;

    _myUid = AuthService.instance.currentUser?.uid;
    // Subscribe to users collection to load opponents (exclude current user)
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      final docs = snapshot.docs;
      final filtered = docs.where((d) => d.id != _myUid).toList();
      final fighters = filtered.map((d) => _mapProfileToFighter(d.data())).toList();
      final uids = filtered.map((d) => d.id).toList();
      setState(() {
        _fighters = fighters;
        _uids = uids;
        if (_fighters.isEmpty) {
          index = 0;
        } else {
          index = index % _fighters.length;
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant SwipePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller?.skip = _skip;
      widget.controller?.challenge = _challenge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _fighters.isNotEmpty;
    final fighter = hasData ? _fighters[index % _fighters.length] : _mapProfileToFighter({});

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          positionX += details.delta.dx;
          angle = positionX / 300;
        });
      },
      onPanEnd: (_) => _onSwipeEnd(),
      child: Center(
        child: hasData
            ? Transform.translate(
          offset: Offset(positionX, 0),
          child: Transform.rotate(
            angle: angle,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: ((200 - positionX.abs()) / 200).clamp(0.0, 1.0),
              child: FighterCard(
                fighter: fighter,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(
                        fighter: fighter,
                        uid: _uids.isEmpty ? null : _uids[index % _uids.length],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
            : const Text(
                'Tidak ada lawan untuk ditampilkan. Cek rules Firestore atau buat profil lain.',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
