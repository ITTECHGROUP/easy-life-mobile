import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Deep graphite backdrop with soft gold/steel glows (pure gradients: light to render, no image edges).
class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff16191D), AppTheme.baseColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _glow(const Alignment(1.3, -1.1), AppTheme.gold.withOpacity(0.12), 1.0),
            _glow(const Alignment(-1.4, 1.2), const Color(0xff5B6B85).withOpacity(0.12), 1.1),
          ],
        ),
      ),
    );
  }

  Widget _glow(Alignment center, Color color, double radius) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(center: center, radius: radius, colors: [color, color.withOpacity(0)]),
        ),
      );
}
