import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/home/home_page.dart';

class WelcomeArenaScreen extends StatelessWidget {
  final String displayName;
  final String martialArt;
  final String? profilePhotoUrl;

  const WelcomeArenaScreen({
    super.key,
    required this.displayName,
    required this.martialArt,
    this.profilePhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700; // iPhone SE, Pixel kecil, dll

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7A3FFF), Color(0xFF2B164A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 40 : 80),

                // TROPHY ICON
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFAFFF8B), Color(0xFF7A3FFF)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Color(0xFFF4EFFF), width: 4),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(8, 8)),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 40),

                // WELCOME TEXT
                const Text(
                  'WELCOME TO THE ARENA!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 26,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 16 : 24),

                // SUBTITLE
                const Text(
                  'Your fighter profile is ready.\nNow find rivals, challenge them, and Chill.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF4EFFF),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const Spacer(), // Dorong ke bawah
                // PROFILE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA96CFF), Color(0xFF7A3FFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFF4EFFF), width: 3),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF4C2C82), offset: Offset(6, 6)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar dengan emoji martial art
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFF4EFFF),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            martialArt.split(' ').last, // ambil emoji terakhir
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Press Start 2P',
                                fontSize: 17,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              martialArt,
                              style: const TextStyle(
                                color: Color(0xFFF4EFFF),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 40),

                // START MATCHING BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) =>
                          false, // Hapus semua halaman sebelumnya (Welcome, Register, dll)
                    );
                  },
                  child: Container(
                    height: 68,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA96CFF), Color(0xFFFF7CFD)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white30, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C2C82),
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'START MATCHING',
                        style: TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 30 : 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
