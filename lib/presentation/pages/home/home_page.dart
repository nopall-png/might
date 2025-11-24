// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/presentation/pages/swipe/swipe_page.dart';
import 'package:wmp/presentation/pages/chat/chat_room_page.dart';
import 'package:wmp/presentation/pages/profile/profile_self_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  child: const SwipePage(),
                ),
              ),

              // ✅ BOTTOM BUTTONS (NOW WITH CONTEXT)
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

  // ✅ HEADER (MESSAGE ICON TANPA NAVIGASI)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // ✅ PROFILE BUTTON (NAVIGATE TO PROFILE PAGE)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileSelfPage()),
                );
              },
              child: _iconButton('assets/icons/profile.svg'),
            ),

            const SizedBox(width: 12),

            // ✅ SETTINGS (NO NAVIGATION YET)
            _iconButton('assets/icons/settings.svg'),
            const SizedBox(width: 12),

            // ✅ MESSAGE ICON (NO NAVIGATION)
            Stack(
              children: [
                _iconButton('assets/icons/msg.svg'),
                Positioned(
                  right: 0,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CFF7A),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        Image.asset('assets/images/logo1.png', height: 64),
      ],
    );
  }

  // ✅ ICON BUTTON
  Widget _iconButton(String svgPath) {
    return Container(
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
  }

  // ✅ BOTTOM BUTTONS (FIXED)
  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _svgButton('assets/icons/cancle.svg', const Color(0xFFFF6C6C)),
        const SizedBox(width: 24),

        // ✅ OPEN CHAT ROOM
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatRoomPage(fighterName: 'Messages'),
              ),
            );
          },
          child: _svgButton('assets/icons/msg.svg', const Color(0xFFA96CFF)),
        ),

        const SizedBox(width: 24),

        // FIGHT BUTTON
        Container(
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
      ],
    );
  }

  // ✅ SVG BUTTON
  Widget _svgButton(String asset, Color bgColor) {
    return Container(
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
  }
}
