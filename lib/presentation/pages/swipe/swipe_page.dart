import 'dart:async';
import 'package:flutter/material.dart';
// Firebase dihapus
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/presentation/pages/widgets/fighter_card.dart';
import 'package:wmp/presentation/pages/match/match_popup.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';
import 'package:wmp/utils/distance_utils.dart';

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
  StreamSubscription<List<Map<String, dynamic>>>? _profilesSub;
  StreamSubscription<AuthUser?>? _authSub;
  StreamSubscription<Map<String, dynamic>?>? _myProfileSub;
  Set<String> _myBlocked = <String>{};
  // Cache semua profil mentah agar bisa re-filter saat blockedIds berubah
  List<Map<String, dynamic>> _allProfiles = const [];
  // Koordinat lokasi saya (untuk jarak)
  double? _myLat;
  double? _myLng;

  Fighter _mapProfileToFighter(Map<String, dynamic> data) {
    final name = (data['displayName'] as String?) ?? 'Fighter';
    final ageVal = data['age'];
    final age = ageVal is int
        ? ageVal
        : int.tryParse(ageVal?.toString() ?? '') ?? 20;
    final style = (data['martialArt'] as String?) ?? '—';
    final about = (data['about'] as String?) ?? 'Ready to fight and train.';
    final exp = (data['experience'] as String?) ?? 'beginner';
    final weightVal = data['weightKg'];
    final heightVal = data['heightCm'];
    final weightStr = weightVal is int
        ? '${weightVal} kg'
        : (weightVal is String && weightVal.isNotEmpty
              ? '${weightVal} kg'
              : '—');
    final heightStr = heightVal is int
        ? '${heightVal} cm'
        : (heightVal is String && heightVal.isNotEmpty
              ? '${heightVal} cm'
              : '—');
    final photoUrl = (data['photoUrl'] as String?)?.trim();
    final locationStr = (data['location'] as String?)?.trim();
    // Hitung jarak jika koordinat tersedia
    double distKm = 0.0;
    final theirLatAny = data['lat'];
    final theirLngAny = data['lng'];
    final theirLat = (theirLatAny is num)
        ? theirLatAny.toDouble()
        : double.tryParse(theirLatAny?.toString() ?? '');
    final theirLng = (theirLngAny is num)
        ? theirLngAny.toDouble()
        : double.tryParse(theirLngAny?.toString() ?? '');
    if (_myLat != null &&
        _myLng != null &&
        theirLat != null &&
        theirLng != null) {
      // Import util Haversine
      distKm = distanceKm(
        lat1: _myLat!,
        lon1: _myLng!,
        lat2: theirLat,
        lon2: theirLng,
      );
    }
    // Tentukan label lokasi: gunakan field 'location' jika ada,
    // jika kosong namun koordinat tersedia, tampilkan koordinat sebagai fallback.
    final locationLabel = (locationStr?.isNotEmpty == true)
        ? locationStr!
        : (theirLat != null && theirLng != null
              ? '${theirLat.toStringAsFixed(4)}, ${theirLng.toStringAsFixed(4)}'
              : 'Unknown');

    return Fighter(
      name: name,
      age: age,
      martialArt: style,
      bio: about,
      imagePath: (photoUrl != null && photoUrl.isNotEmpty)
          ? photoUrl
          : 'assets/images/dummyimage.jpg',
      experience: exp,
      distance: distKm,
      location: locationLabel,
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
    // Jika UID belum tersedia (race condition), tunggu perubahan auth
    if (_myUid == null) {
      _authSub = AuthService.instance.authStateChanges.listen((user) {
        if (user?.uid != null) {
          _myUid = user!.uid;
          _startMyProfileStream();
          _startProfilesStream();
          // Setelah UID didapat, kita tidak perlu mendengar auth lagi
          _authSub?.cancel();
          _authSub = null;
        }
      });
    }
    // Jika UID sudah ada, langsung mulai stream
    _startMyProfileStream();
    _startProfilesStream();
  }

  void _startMyProfileStream() {
    if (_myUid == null) return;
    _myProfileSub?.cancel();
    _myProfileSub = FirestoreService.instance.streamUserProfile(_myUid!).listen(
      (profile) {
        final blocked = (profile?['blockedIds'] is List)
            ? List<String>.from(profile!['blockedIds'])
            : <String>[];
        // Ambil koordinat saya
        final myLatAny = profile?['lat'];
        final myLngAny = profile?['lng'];
        final lat = (myLatAny is num)
            ? myLatAny.toDouble()
            : double.tryParse(myLatAny?.toString() ?? '');
        final lng = (myLngAny is num)
            ? myLngAny.toDouble()
            : double.tryParse(myLngAny?.toString() ?? '');
        setState(() {
          _myBlocked = blocked.toSet();
          _myLat = lat;
          _myLng = lng;
        });
        // Re-filter daftar ketika blockedIds saya berubah
        _applyFilter();
      },
    );
  }

  void _startProfilesStream() {
    // Pastikan tidak ada langganan lama yang aktif
    _profilesSub?.cancel();
    _profilesSub = FirestoreService.instance
        .streamAllProfiles(excludeUid: _myUid)
        .listen((list) {
          // Simpan cache semua profil, lalu terapkan filter
          _allProfiles = list;
          _applyFilter();
        });
  }

  void _applyFilter() {
    // Filter dua arah: sembunyikan jika mereka memblokir saya atau saya memblokir mereka
    final filtered = _allProfiles.where((d) {
      final theirUid = d['uid'] as String?;
      if (theirUid == null) return false;
      final theirBlocked = (d['blockedIds'] is List)
          ? List<String>.from(d['blockedIds']).toSet()
          : <String>{};
      final theyBlockedMe = _myUid != null && theirBlocked.contains(_myUid);
      final iBlockedThem = _myBlocked.contains(theirUid);
      return !(theyBlockedMe || iBlockedThem);
    }).toList();
    // Buat pasangan (fighter, uid) lalu urutkan berdasarkan jarak terdekat
    final pairs = filtered.map((d) {
      final f = _mapProfileToFighter(d);
      final uid = d['uid'] as String;
      return {'f': f, 'uid': uid};
    }).toList();
    pairs.sort((a, b) {
      final da = (a['f'] as Fighter).distance;
      final db = (b['f'] as Fighter).distance;
      final aHas = da > 0;
      final bHas = db > 0;
      if (aHas && bHas) return da.compareTo(db); // keduanya punya jarak
      if (aHas && !bHas) return -1; // a lebih prioritas
      if (!aHas && bHas) return 1; // b lebih prioritas
      return 0; // keduanya tanpa jarak, pertahankan urutan relatif
    });
    final fighters = pairs.map((e) => e['f'] as Fighter).toList();
    final uids = pairs.map((e) => e['uid'] as String).toList();
    setState(() {
      _fighters = fighters;
      _uids = uids;
      index = _fighters.isEmpty ? 0 : index % _fighters.length;
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
  void dispose() {
    _profilesSub?.cancel();
    _authSub?.cancel();
    _myProfileSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _fighters.isNotEmpty;
    final fighter = hasData
        ? _fighters[index % _fighters.length]
        : _mapProfileToFighter({});

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
                              uid: _uids.isEmpty
                                  ? null
                                  : _uids[index % _uids.length],
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
