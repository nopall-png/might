import 'dart:async';
import 'package:flutter/material.dart';
import '../onboarding/onboarding_page1.dart';
import '../home/home_page.dart';
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/matches_notification_service.dart';
import 'package:wmp/data/services/chat_notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // animation controller untuk titik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // pindah sesuai status login setelah 2 detik
    Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;
      final isLoggedIn = AuthService.instance.currentUser != null;
      // Start matches notifications when logged in
      if (isLoggedIn) {
        final uid = AuthService.instance.currentUser!.uid;
        await MatchesNotificationService.instance.startListening(uid);
        await ChatNotificationService.instance.startListening(uid);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => isLoggedIn ? const HomePage() : const OnboardingPage1()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7936FF), Color(0xFF2D0B57)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.only(top: 64, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Container(
              width: 260,
              height: 210,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // TAGLINE
            const Text(
              'Match. Clash. Chill.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF4EFFF),
                fontSize: 16,
                fontFamily: 'Arial',
                height: 1.62,
              ),
            ),

            const SizedBox(height: 48),

            // LOADING DOTS
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                int activeDot = (_controller.value * 3).floor().clamp(0, 2);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: index == activeDot
                              ? const Color(0xFFFF7CFD)
                              : const Color(0xFFFF7CFD).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
