import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  final Fighter fighter;

  const ProfilePage({super.key, required this.fighter});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width - 48;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ 1. HEADER
              _buildHeader(context),

              const SizedBox(height: 24),

              // ✅ 2. PROFILE
              _buildProfileCard(cardWidth),

              const SizedBox(height: 24),

              _buildExperienceLevel(),

              const SizedBox(height: 24),

              // ✅ 4. STATISTICS
              _buildStatisticsSection(),

              const SizedBox(height: 24),

              // ✅ 5. ABOUT ME
              _buildSection(
                title: 'ABOUT ME',
                child: Text(
                  fighter.bio,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Color(0xFF1F1A2E),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ✅ CHALLENGE BUTTON
              _buildChallengeButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ HEADER
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const Text(
            'Your Opponent',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFFF5EFFF),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ✅ PROFILE CARD
  Widget _buildProfileCard(double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7A3FFF), width: 4),
              borderRadius: BorderRadius.circular(64),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image.network(fighter.imagePath, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 20),

          // Name
          Text(
            fighter.name,
            style: const TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 18,
              color: Color(0xFF1F1A2E),
            ),
          ),

          const SizedBox(height: 8),

          // Age
          Text(
            '${fighter.age} years old',
            style: const TextStyle(fontSize: 14, color: Color(0xFFB6A9D7)),
          ),

          const SizedBox(height: 8),

          // Martial Art
          Text(
            fighter.martialArt.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),

          const SizedBox(height: 16),

          // Distance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7A3FFF), width: 2),
            ),
            child: Text(
              '${fighter.distance} km away',
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F1A2E)),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ STATISTICS
  Widget _buildStatisticsSection() {
    return Container(
      width: double.infinity,
      height: 272,
      padding: const EdgeInsets.only(top: 27, left: 27, right: 27, bottom: 3),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Color(0xFF7A3FFF)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(color: Color(0xFFE5D5FF), offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STATISTICS',
            style: TextStyle(
              color: Color(0xFF1F1A2E),
              fontSize: 14,
              fontFamily: 'Press Start 2P',
              letterSpacing: 0.7,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // ===========================
          // ⭐ TOTAL MATCHES CARD
          // ===========================
          Container(
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF5CFF85)),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(color: Color(0xFF4C2C82), offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                // ICON — kosong dulu
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF5CFF85),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/matches.svg",
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // TEXT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Matches',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Arial',
                        color: Color(0xFFF5EFFF),
                      ),
                    ),
                    Text(
                      '${fighter.match} .',
                      style: const TextStyle(
                        fontFamily: 'Press Start 2P',
                        fontSize: 14,
                        color: Color(0xFFF5EFFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===========================
          // ⭐ RECENT MATCH
          // ===========================
          Container(
            height: 84,
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: const Color(0xFFF5EFFF),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF7A3FFF)),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(color: Color(0xFFE5D5FF), offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                // ICON — kosong dulu
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/recent.svg",
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Match',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFFB6A9D7),
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        // Avatar mini (placeholder)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Color(0xFF7A3FFF),
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fighter.lastMatch,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1F1A2E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Small info box
  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF7A3FFF), width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A3FFF)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1F1A2E)),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceLevel() {
    return Container(
      width: double.infinity,
      height: 144,
      padding: const EdgeInsets.only(top: 27, left: 27, right: 27, bottom: 3),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: Color(0xFF7A3FFF)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(color: Color(0xFFE5D5FF), offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXPERIENCE LEVEL',
            style: TextStyle(
              color: Color(0xFF1F1A2E),
              fontSize: 14,
              fontFamily: 'Press Start 2P',
              letterSpacing: 0.7,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // 🌈 Gradient Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 3, color: Color(0xFF5CFF85)),
                borderRadius: BorderRadius.circular(14),
              ),
              shadows: const [
                BoxShadow(color: Color(0x665CFF85), blurRadius: 20),
                BoxShadow(color: Color(0xFF4C2C82), offset: Offset(0, 4)),
              ],
            ),

            // ⭐ LEVEL TEXT
            child: Text(
              fighter.experience,
              style: const TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 14,
                height: 1.4,
                letterSpacing: 0.7,
                color: Color(0xFFF5EFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ REUSABLE SECTION
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ✅ CHALLENGE BUTTON
  Widget _buildChallengeButton() {
    return GestureDetector(
      onTap: () {
        // TODO: OPEN MATCH POPUP
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Challenge 🥊',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 16,
              color: Color(0xFFF5EFFF),
            ),
          ),
        ),
      ),
    );
  }
}
