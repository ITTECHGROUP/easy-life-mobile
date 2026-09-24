import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_theme.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          // color: AppTheme.primary,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A1E23),
                AppTheme.primary,
              ],
              stops: [0.2, 0.8],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        const Positioned(
          top: -150,
          right: -200,
          child: _CircularGradientBox(size: 450),
        ),
        const Positioned(
          top: -200,
          right: -100,
          child: _CircularGradientBox(size: 300),
        ),
        //
        const Positioned(
          bottom: -50,
          left: -200,
          child: _CircularGradientBox(size: 450),
        ),
        const Positioned(
          bottom: -100,
          left: -100,
          child: _CircularGradientBox(size: 300),
        ),
      ],
    );
  }
}

class _BlurEllipse extends StatefulWidget {
  const _BlurEllipse({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  State<_BlurEllipse> createState() => _BlurEllipseState();
}

class _BlurEllipseState extends State<_BlurEllipse> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 1,
      child: Image(
        // width: size.width,
        height: widget.size.height,
        fit: BoxFit.fill,
        color: Colors.black.withOpacity(0),
        colorBlendMode: BlendMode.difference,
        image: const AssetImage(
          "assets/gradient.png",
        ),
      ),
    );
  }
}

class _CircularGradientBox extends StatelessWidget {
  const _CircularGradientBox({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0,
      child: Image(
        width: size,
        fit: BoxFit.fill,
        colorBlendMode: BlendMode.color,
        image: const AssetImage(
          "assets/Ellipse 63.png",
        ),
      ),
    );
  }
}
