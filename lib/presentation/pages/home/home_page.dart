// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/match/match_popup.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/presentation/pages/swipe/swipe_page.dart';
import 'package:wmp/routes/app_routes.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';
import 'package:wmp/data/models/chat_dummy.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Controller to trigger skip/challenge actions on SwipePage
  static final SwipeController _swipeController = SwipeController();

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
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: _buildHeader(context),
              ),

              // SWIPE AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SwipePage(controller: _swipeController),
                ),
              ),

              // BOTTOM BUTTONS
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _buildBottomButtons(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ HEADER
  Widget _buildHeader(BuildContext context) {
    final unreadCount = chatItems.fold<int>(
      0,
      (sum, item) => sum + item.unread,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _iconButton(
              'assets/icons/profile.svg',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            const SizedBox(width: 12),
            _iconButton(
              'assets/icons/msg.svg',
              onTap: () => Navigator.pushNamed(context, AppRoutes.matches),
              badgeCount: unreadCount,
            ),
            const SizedBox(width: 12),
            _iconButton(
              'assets/icons/settings.svg',
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          ],
        ),
        Image.asset('assets/images/logo1.png', height: 48),
      ],
    );
  }

  // ✅ ICON BUTTON
  Widget _iconButton(String svgPath, {VoidCallback? onTap, int? badgeCount}) {
    final baseIcon = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFA96CFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(3, 3)),
        ],
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        color: Colors.white,
      ),
    );

    final withBadge = Stack(
      clipBehavior: Clip.none,
      children: [
        baseIcon,
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF5CFF85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF4C2C82), offset: Offset(2, 2)),
                ],
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: withBadge)
        : withBadge;
  }

  // ✅ BOTTOM BUTTONS
  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _svgButton(
          'assets/icons/cancle.svg',
          const Color(0xFFFF6C6C),
          onTap: () {
            // X button triggers SKIP on current card
            _swipeController.skip?.call();
          },
        ),
        const SizedBox(width: 24),
        _svgButton(
          'assets/icons/msg.svg',
          const Color(0xFFA96CFF),
          onTap: () {
            // Buka daftar Matches Notification, bukan langsung ke chat room kosong
            Navigator.pushNamed(context, AppRoutes.matches);
          },
        ),
        const SizedBox(width: 24),

        // FIGHT BUTTON
        GestureDetector(
          onTap: () {
            // Route Fight button: open MatchPopup with a dummy fighter
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => MatchPopup(
                fighter: Fighter(
                  name: 'Alex',
                  age: 25,
                  martialArt: 'Boxing',
                  bio: 'Ready to spar and plan the next session.',
                  imagePath: 'assets/images/dummyimage2.jpg',
                  experience: 'intermediate',
                  distance: 2.0,
                  match: '12 matches',
                  weight: '70 kg',
                  height: '175 cm',
                  lastMatch: 'Fought with Sam',
                ),
              ),
            );
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Color(0xFF4C2C82), offset: Offset(6, 6)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                'assets/images/fight.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ SVG BUTTON
  Widget _svgButton(String asset, Color bgColor, {VoidCallback? onTap}) {
    final button = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(6, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(asset, color: Colors.white),
      ),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: button)
        : button;
  }
}
