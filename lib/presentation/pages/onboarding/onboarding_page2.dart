import 'package:flutter/material.dart';
import 'onboarding_page3.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 64, bottom: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7936FF), Color(0xFF2D0B57)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(isActive: false),
                const SizedBox(width: 8),
                _dot(isActive: true),
                const SizedBox(width: 8),
                _dot(isActive: false),
              ],
            ),

            /// MAIN CONTENT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ICON BOX
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A3FFF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        width: 4,
                        color: const Color(0xFF2B164A),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C2C82),
                          offset: Offset(8, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.group, size: 64, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 48),

                  /// TITLE
                  const Text(
                    'TRAIN TOGETHER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF9F8FF),
                      fontSize: 18,
                      fontFamily: 'Press Start 2P',
                      letterSpacing: 0.9,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// SUBTITLE
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Build your community, spar with friends, and level up together',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF4EFFF),
                        fontSize: 16,
                        height: 1.62,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM SECTION (BUTTON + SKIP)
            Column(
              children: [
                /// BUTTON NEXT
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage3(),
                      ),
                    );
                  },
                  child: Container(
                    width: 384,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(width: 3, color: Colors.white30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C2C82),
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          color: Color(0xFFF9F8FF),
                          fontSize: 14,
                          fontFamily: 'Press Start 2P',
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// SKIP
                const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFFF4EFFF), fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// DOT WIDGET
  Widget _dot({required bool isActive}) {
    return Container(
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFA96CFF),
        borderRadius: BorderRadius.circular(50),
        boxShadow: isActive
            ? const [BoxShadow(color: Color(0xFFF4EFFF), offset: Offset(2, 2))]
            : null,
      ),
    );
  }
}
