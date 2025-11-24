import 'package:flutter/material.dart';
import 'package:wmp/data/models/fighter_dummy.dart';
import 'package:wmp/presentation/pages/widgets/fighter_card.dart';
import 'package:wmp/presentation/pages/match/match_popup.dart';
import 'package:wmp/presentation/pages/profile/profile_page.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  int index = 0;
  double positionX = 0;
  double angle = 0;

  void _showMatchPopup(fighter) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MatchPopup(fighter: fighter),
    );
  }

  void _nextCard() {
    setState(() {
      index = (index + 1) % dummyFighters.length;
      positionX = 0;
      angle = 0;
    });
  }

  void _onSwipeEnd() {
    final fighter = dummyFighters[index];

    if (positionX > 120) {
      print("CHALLENGE ✅");
      _showMatchPopup(fighter);
      _nextCard();
    } else if (positionX < -120) {
      print("SKIP ❌");
      _nextCard();
    } else {
      setState(() {
        positionX = 0;
        angle = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fighter = dummyFighters[index];

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          positionX += details.delta.dx;
          angle = positionX / 300;
        });
      },
      onPanEnd: (_) => _onSwipeEnd(),
      child: Center(
        child: Transform.translate(
          offset: Offset(positionX, 0),
          child: Transform.rotate(
            angle: angle,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: ((200 - positionX.abs()) / 200).clamp(0.0, 1.0),
              child: FighterCard(
                fighter: fighter,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(fighter: fighter),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
