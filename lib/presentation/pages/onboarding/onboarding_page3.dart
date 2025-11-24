import 'package:flutter/material.dart';
import 'package:wmp/presentation/pages/auth/login_page.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

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
            /// DOT INDICATOR (3rd active)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(false),
                const SizedBox(width: 8),
                _dot(false),
                const SizedBox(width: 8),
                _dot(true),
              ],
            ),

            /// MAIN CONTENT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ICON BOX (GREEN)
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAFFF8B),
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
                      child: Icon(
                        Icons.flash_on,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  /// TITLE
                  const Text(
                    'Fight. Win. Repeat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF9F8FF),
                      fontSize: 18,
                      fontFamily: 'Press Start 2P',
                      letterSpacing: 0.9,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// DESCRIPTION
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Face real opponents, earn glory, and prove your strength.',
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

            /// BUTTON GET STARTED
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Container(
                width: 384,
                height: 62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(width: 3, color: Colors.white30),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'GET STARTED',
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
          ],
        ),
      ),
    );
  }

  /// DOT WIDGET
  Widget _dot(bool active) {
    return Container(
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFA96CFF),
        borderRadius: BorderRadius.circular(50),
        boxShadow: active
            ? const [BoxShadow(color: Color(0xFFF4EFFF), offset: Offset(2, 2))]
            : null,
      ),
    );
  }
}
