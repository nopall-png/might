import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/data/models/chat_item.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';

class MatchingFightPage extends StatelessWidget {
  const MatchingFightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final ChatItem? item = args is ChatItem ? args : null;

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
              // Header with back
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
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "It's a Match!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontFamily: 'Press Start 2P',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Match card with neon border and exact design details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Outer neon border & glow
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFF5CFF85),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x885CFF85),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8A53FF), Color(0xFF7A3FFF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF4C2C82),
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "IT'S A MATCH!",
                              style: TextStyle(
                                fontFamily: 'Press Start 2P',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            // trio lightning
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/lightning.svg',
                                  width: 18,
                                  height: 18,
                                  color: const Color(0xFF5CFF85),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/lightning.svg',
                                  width: 18,
                                  height: 18,
                                  color: const Color(0xFF5CFF85),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/lightning.svg',
                                  width: 18,
                                  height: 18,
                                  color: const Color(0xFF5CFF85),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // avatars + vs with badges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _avatarBox(
                                  imageAsset: 'assets/images/logo1.png',
                                  badgeAsset: 'assets/icons/spark.svg',
                                  badgeBgColor: const Color(0xFF2B164A),
                                  badgeTintColor: const Color(0xFF5CFF85),
                                ),
                                _vsBox(),
                                _avatarBox(
                                  imageAsset:
                                      item?.avatarAsset ??
                                      'assets/images/dummyimage.jpg',
                                  badgeAsset: 'assets/icons/lightning.svg',
                                  badgeBgColor: const Color(0xFF2B164A),
                                  badgeTintColor: const Color(0xFFFF7CFD),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // You and <name> both want to spar!
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFF5EFFF),
                                ),
                                children: [
                                  const TextSpan(text: 'You and '),
                                  TextSpan(
                                    text: item?.name ?? 'Unknown Fighter',
                                    style: const TextStyle(
                                      fontFamily: 'Press Start 2P',
                                      fontSize: 14,
                                      color: Color(0xFF5CFF85),
                                    ),
                                  ),
                                  const TextSpan(text: ' both want to spar!'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Challenge Profile button with icon
                            GestureDetector(
                              onTap: () {
                                final fighter = Fighter(
                                  name: item?.name ?? 'Unknown Fighter',
                                  age: 24,
                                  martialArt: item?.style ?? 'Muay Thai',
                                  bio:
                                      'Ready to spar and plan the next session. Tap to chat or see more details.',
                                  imagePath:
                                      item?.avatarAsset ??
                                      'assets/images/dummyimage.jpg',
                                  experience: 'beginner',
                                  distance: 1.2,
                                  location: 'Unknown',
                                  match: '12 matches',
                                  weight: '70 kg',
                                  height: '175 cm',
                                  lastMatch: 'N/A',
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProfilePage(fighter: fighter),
                                  ),
                                );
                              },
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5CFF85),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF4C2C82),
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/msg.svg',
                                      color: const Color(0xFF2B164A),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Challenge Profile',
                                      style: TextStyle(
                                        fontFamily: 'Press Start 2P',
                                        fontSize: 14,
                                        color: Color(0xFF2B164A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Cancel button with x icon
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B164A),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/cancle.svg',
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
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
                    // corner spark decoration (larger)
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A3FFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF4C2C82),
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/icons/spark.svg',
                            color: const Color(0xFF5CFF85),
                          ),
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
    );
  }

  Widget _avatarBox({
    required String imageAsset,
    String? badgeAsset,
    Color? badgeBgColor,
    Color? badgeTintColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF7A3FFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
        ),
        if (badgeAsset != null)
          Positioned(
            bottom: -6,
            right: -6,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: badgeBgColor ?? const Color(0xFF2B164A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF4C2C82), offset: Offset(2, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  badgeAsset,
                  color: badgeTintColor ?? Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _vsBox() {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF5CFF85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
        ],
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          fontFamily: 'Press Start 2P',
          fontSize: 14,
          color: Color(0xFF2B164A),
        ),
      ),
    );
  }
}
