import 'package:flutter/material.dart';

class ResponsiveGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final double height;
  final List<Color> gradientColors;

  const ResponsiveGradientAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.height = 72,
    this.gradientColors = const [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Back button or spacer
                  if (onBack != null)
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EFFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    )
                  else
                    const SizedBox(width: 40, height: 40),

                  const SizedBox(width: 8),

                  // Title centered and responsive
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Press Start 2P',
                            fontSize: 16,
                            color: Color(0xFFF5EFFF),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Actions or spacer to keep symmetry
                  if (actions != null && actions!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    )
                  else
                    const SizedBox(width: 40, height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

