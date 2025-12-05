import 'package:flutter/material.dart';
import 'package:wmp/routes/app_routes.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/data/services/location_service.dart';
import 'package:wmp/data/services/matches_notification_service.dart';
import 'package:wmp/data/services/chat_notification_service.dart';
// Removed ProfilePage import; we navigate to Edit Profile via routes

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA96CFF),
                          borderRadius: BorderRadius.circular(10),
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
                          size: 20,
                        ),
                      ),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _section(
                        title: 'About',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'App Version',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              appVersion,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Blocked Users Section
                      _blockedUsersSection(context),

                      const SizedBox(height: 16),

                      _section(
                        title: 'Account',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // View My Profile button → navigates to Edit Profile
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA96CFF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                final uid =
                                    AuthService.instance.currentUser?.uid;
                                if (uid == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        'Harap login terlebih dahulu',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                );
                              },
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Perbarui lokasi (simpan lat/lng ke profil)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A3FFF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () async {
                                final uid =
                                    AuthService.instance.currentUser?.uid;
                                if (uid == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        'Harap login terlebih dahulu',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Mengambil lokasi…'),
                                  ),
                                );
                                final ok = await LocationService.instance
                                    .updateMyLocationToProfile();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ok
                                        ? const Color(0xFF4CAF50)
                                        : Colors.redAccent,
                                    content: Text(
                                      ok
                                          ? 'Lokasi berhasil diperbarui'
                                          : 'Gagal memperbarui lokasi (izin ditolak atau layanan nonaktif)',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Perbarui lokasi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Logout button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6C6C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () async {
                                // Stop notifications listeners to mencegah kebocoran
                                await MatchesNotificationService.instance.stopListening();
                                await ChatNotificationService.instance.stopListening();
                                // Logout, lalu bersihkan stack
                                await AuthService.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.login,
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

  Widget _blockedUsersSection(BuildContext context) {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      return _section(
        title: 'Blocked Users',
        child: const Text(
          'Silakan login untuk melihat daftar pengguna yang diblokir.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );
    }

    return _section(
      title: 'Blocked Users',
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: FirestoreService.instance.streamUserProfile(uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }
          final data = snap.data;
          final ids = (data?['blockedIds'] is List)
              ? List<String>.from(
                  data!['blockedIds'],
                ).where((e) => e.isNotEmpty).toList()
              : <String>[];
          if (ids.isEmpty) {
            return const Text(
              'Tidak ada pengguna yang diblokir.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            );
          }

          return FutureBuilder<List<Map<String, dynamic>?>>(
            future: Future.wait(
              ids.map((id) => FirestoreService.instance.getUserProfile(id)),
            ),
            builder: (context, profSnap) {
              if (profSnap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              final profiles = (profSnap.data ?? [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
              if (profiles.isEmpty) {
                return const Text(
                  'Tidak ada pengguna yang diblokir.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                );
              }

              return Column(
                children: profiles.map((p) {
                  final targetUid = p['uid'] as String?;
                  final name = (p['displayName'] as String?) ?? 'Unknown';
                  final photo = (p['photoUrl'] as String?)?.trim();
                  final img = (photo != null && photo.isNotEmpty)
                      ? NetworkImage(photo)
                      : const AssetImage('assets/images/dummyimage.jpg');
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A3FFF).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: img as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFA96CFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: targetUid == null
                              ? null
                              : () async {
                                  await FirestoreService.instance.unblockUser(
                                    myUid: uid,
                                    targetUid: targetUid,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Unblocked $name'),
                                      ),
                                    );
                                  }
                                },
                          child: const Text('Unblock'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7A3FFF).withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(6, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
