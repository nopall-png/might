import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/presentation/pages/profile/edit_profile_page.dart';

class ProfileSelfPage extends StatelessWidget {
  const ProfileSelfPage({super.key});

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
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildProfileCard(cardWidth),
              const SizedBox(height: 24),
              _buildExperienceLevel(),
              const SizedBox(height: 24),
              _buildStatisticsSection(),
              const SizedBox(height: 24),
              _buildAboutMe(),
              const SizedBox(height: 32),
              _buildEditProfileButton(context),
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
            'My Profile',
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
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7A3FFF), width: 4),
              borderRadius: BorderRadius.circular(64),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image.asset('assets/images/user.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Name',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 18,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '19 years old',
            style: TextStyle(fontSize: 14, color: Color(0xFFB6A9D7)),
          ),
          const SizedBox(height: 8),
          const Text(
            'MUAY THAI',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7A3FFF), width: 2),
            ),
            child: const Text(
              '0 km away',
              style: TextStyle(fontSize: 14, color: Color(0xFF1F1A2E)),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ EXPERIENCE
  Widget _buildExperienceLevel() {
    return Container(
      width: double.infinity,
      height: 144,
      padding: const EdgeInsets.only(top: 27, left: 27, right: 27),
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
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),
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
            ),
            child: const Text(
              'Beginner',
              style: TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 14,
                color: Color(0xFFF5EFFF),
              ),
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
      padding: const EdgeInsets.only(top: 27, left: 27, right: 27),
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
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),
          // ✅ TOTAL MATCHES
          Container(
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF5CFF85)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
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
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Matches',
                      style: TextStyle(fontSize: 14, color: Color(0xFFF5EFFF)),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
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
          // ✅ RECENT MATCH
          Container(
            height: 84,
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: const Color(0xFFF5EFFF),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF7A3FFF)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Match',
                      style: TextStyle(fontSize: 14, color: Color(0xFFB6A9D7)),
                    ),
                    Text(
                      '-',
                      style: TextStyle(fontSize: 16, color: Color(0xFF1F1A2E)),
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

  // ✅ ABOUT ME
  Widget _buildAboutMe() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFF7A3FFF), width: 3),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT ME',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Tell something about yourself...',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF1F1A2E),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ EDIT PROFILE BUTTON (NOW WORKING)
  Widget _buildEditProfileButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfilePage()),
        );
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
            'Edit Profile ✏️',
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
