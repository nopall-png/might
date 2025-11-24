import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_model.dart';

class MatchPopup extends StatelessWidget {
  final Fighter fighter;

  const MatchPopup({super.key, required this.fighter});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF4EFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFF7A3FFF), width: 4),
          boxShadow: const [
            BoxShadow(color: Color(0xFF4C2C82), offset: Offset(12, 12)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "IT'S A MATCH!",
              style: TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 22,
                color: Color(0xFF7A3FFF),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ FOTO FIGHTER
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF7A3FFF), width: 4),
                image: DecorationImage(
                  image: NetworkImage(fighter.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'You matched with',
              style: TextStyle(fontSize: 16, color: Color(0xFF2B164A)),
            ),

            const SizedBox(height: 8),

            Text(
              fighter.name,
              style: TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 16,
                color: Color(0xFF7A3FFF),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Text(
              'Start chatting and plan your first session!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF4C2C82)),
            ),

            const SizedBox(height: 28),

            // ✅ BUTTON START MATCHING
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // nanti bisa diarahkan ke chat
              },
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA96CFF), Color(0xFFFF7CFD)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Text(
                  'START MATCHING',
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
