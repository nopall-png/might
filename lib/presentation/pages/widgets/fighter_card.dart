import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_model.dart';

class FighterCard extends StatelessWidget {
  final Fighter fighter;
  final VoidCallback? onTap; // ✅ callback ketika card diklik

  const FighterCard({super.key, required this.fighter, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 60;

    return GestureDetector(
      onTap: onTap, // ✅ klik card
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(4),
        decoration: ShapeDecoration(
          color: const Color(0xFFF4EFFF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 4, color: Color(0xFF7A3FFF)),
            borderRadius: BorderRadius.circular(28),
          ),
          shadows: const [
            BoxShadow(color: Color(0xFF4C2C82), offset: Offset(8, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: double.infinity,
                height: 240,
                child: Stack(
                  children: [
                    // Gunakan foto dari database jika berupa URL, selain itu fallback ke asset
                    if (fighter.imagePath.startsWith('http'))
                      Image.network(
                        fighter.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (ctx, err, stack) => Image.asset(
                          'assets/images/dummyimage.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    else
                      Image.asset(
                        fighter.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                    // LOCATION BADGE
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A3FFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF9F8FF),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF4C2C82),
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          fighter.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + AGE
                  Text(
                    '${fighter.name}, ${fighter.age}',
                    style: const TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 17,
                      color: Color(0xFF2B164A),
                      letterSpacing: 0.8,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // MARTIAL ART
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF4EFFF),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      fighter.martialArt.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // BIO
                  Text(
                    fighter.bio,
                    style: const TextStyle(
                      color: Color(0xFF4C2C82),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
