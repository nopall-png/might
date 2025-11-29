import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'onboarding_page2.dart';
import 'package:wmp/presentation/widgets/page_transitions.dart';
import 'package:wmp/presentation/pages/auth/login_page.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D0B57),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 64, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ---------- PROGRESS DOTS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _activeDot(),
                const SizedBox(width: 8),
                _inactiveDot(),
                const SizedBox(width: 8),
                _inactiveDot(),
              ],
            ),

            // ---------- CONTENT ----------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- ICON / LOGO BOX ---
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7CFD),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF2B164A),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C2C82),
                          offset: Offset(8, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/swords.svg",
                        width: 64,
                        height: 64,
                      ),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // --- TITLE ---
                  const Text(
                    "FIND YOUR RIVAL",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF9F8FF),
                      fontSize: 18,
                      fontFamily: 'Press Start 2P',
                      height: 1.4,
                      letterSpacing: 0.9,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- DESCRIPTION ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Connect with fighters nearby who match your skill level and style',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF4EFFF),
                        fontSize: 16,
                        fontFamily: 'Arial',
                        height: 1.62,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- BUTTONS ----------
            Column(
              children: [
                // NEXT BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(slideFadeRoute(const OnboardingPage2()));
                  },
                  child: Container(
                    width: 384,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
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
                        "NEXT",
                        style: TextStyle(
                          color: Color(0xFFF9F8FF),
                          fontSize: 14,
                          fontFamily: "Press Start 2P",
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // SKIP TEXT → go to Login
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      slideFadeRoute(const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Color(0xFFF4EFFF), fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- DOTS ---
  Widget _activeDot() => Container(
    width: 24,
    height: 8,
    decoration: BoxDecoration(
      color: const Color(0xFFA96CFF),
      borderRadius: BorderRadius.circular(50),
      boxShadow: const [
        BoxShadow(color: Color(0xFFF4EFFF), offset: Offset(2, 2)),
      ],
    ),
  );

  Widget _inactiveDot() => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      color: const Color(0xFFA96CFF),
      borderRadius: BorderRadius.circular(50),
    ),
  );
}
