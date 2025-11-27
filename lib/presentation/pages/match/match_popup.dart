import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wmp/data/models/fighter_model.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';

class MatchPopup extends StatelessWidget {
  final Fighter fighter;
  final String? opponentUid;

  const MatchPopup({super.key, required this.fighter, this.opponentUid});

  @override
  Widget build(BuildContext context) {
    final maxDialogWidth = (MediaQuery.of(context).size.width - 80).clamp(280.0, 380.0);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        // Hindari overflow: gunakan lebar maksimum responsif
        constraints: BoxConstraints(maxWidth: maxDialogWidth),
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
            const SizedBox(height: 18),

            // 🔥 Dekorasi lightning di atas avatar (scale down if needed)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/lightning.svg', width: 22, height: 22, color: const Color(0xFFA96CFF)),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/lightning.svg', width: 28, height: 28, color: const Color(0xFFFF7CFD)),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/lightning.svg', width: 22, height: 22, color: const Color(0xFFA96CFF)),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 👥 Dua avatar dan kotak VS di tengah (responsif)
            LayoutBuilder(
              builder: (context, constraints) {
                final available = constraints.maxWidth;
                // Total spacer+VS width = 82
                final avatarSide = ((available - 82) / 2).clamp(70.0, 110.0);
                // Gunakan Wrap untuk menghindari overflow horizontal
                return Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    // Avatar kiri (user/dummy)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: avatarSide,
                          height: avatarSide,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF7A3FFF), width: 4),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/dummyimage.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -8,
                          bottom: -8,
                          child: SvgPicture.asset('assets/icons/spark.svg', width: 24, height: 24),
                        ),
                      ],
                    ),

                    // Kotak VS
                    Container(
                      width: 54,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7CFD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF4C2C82), offset: Offset(4, 4)),
                        ],
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontFamily: 'Press Start 2P',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Avatar kanan (fighter matched) - gunakan foto dari database
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: avatarSide,
                          height: avatarSide,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF7A3FFF), width: 4),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: (fighter.imagePath.startsWith('http'))
                              ? Image.network(
                                  fighter.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (ctx, err, stack) => Image.asset(
                                    'assets/images/dummyimage2.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/dummyimage2.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                        Positioned(
                          left: -8,
                          bottom: -8,
                          child: SvgPicture.asset('assets/icons/lightning.svg', width: 24, height: 24, color: const Color(0xFFA96CFF)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Nama fighter di bawah
            Text(
              fighter.name,
              style: const TextStyle(
                fontFamily: 'Press Start 2P',
                fontSize: 16,
                color: Color(0xFF7A3FFF),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 22),

            // Tombol CHALLENGE PROFILE
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(fighter: fighter, uid: opponentUid),
                  ),
                );
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
                child: const Text(
                  'CHALLENGE PROFILE',
                  style: TextStyle(
                    fontFamily: 'Press Start 2P',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Tombol Cancel
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF7A3FFF), width: 3),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A3FFF),
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
