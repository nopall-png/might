import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_model.dart';

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
              // ✅ HEADER
              _buildHeader(context),

              const SizedBox(height: 24),

              // ✅ PROFILE CARD
              _buildProfileCard(cardWidth),

              const SizedBox(height: 24),

              // ✅ STATISTICS
              _buildStatistics(),

              const SizedBox(height: 24),

              // ✅ EXPERIENCE LEVEL
              _buildSection(
                title: 'EXPERIENCE LEVEL',
                child: Center(
                  child: Text(
                    fighter.experience.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 14,
                      color: Color(0xFF1F1A2E),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ✅ ABOUT ME
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

              const SizedBox(height: 24),

              // ✅ MAIN STYLE
              _buildSection(
                title: 'MAIN STYLE',
                child: Center(
                  child: Text(
                    fighter.martialArt.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 16,
                      color: Color(0xFF1F1A2E),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ✅ CHALLENGE BUTTON (OPTIONAL)
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
            '${fighter.age} years old • Male',
            style: const TextStyle(fontSize: 14, color: Color(0xFFB6A9D7)),
          ),

          const SizedBox(height: 16),

          // Location
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
  Widget _buildStatistics() {
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
          const Text(
            'STATISTICS',
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 14,
              color: Color(0xFF1F1A2E),
            ),
          ),
          const SizedBox(height: 16),

          // Total Matches
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF5CFF85), width: 2),
            ),
            child: const Text(
              '12 Matches',
              style: TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 14,
                color: Color(0xFFF5EFFF),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recent Match
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF7A3FFF), width: 2),
            ),
            child: const Text(
              'Fought with Alex',
              style: TextStyle(fontSize: 16, color: Color(0xFF1F1A2E)),
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
        // TODO: Open Match Popup
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
