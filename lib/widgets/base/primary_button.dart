import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    Key? key,
    // required this.onPressed,
    required this.text,
  }) : super(key: key);

  // final void Function onPressed;
  // final CallbackAction onPressed;
  final String text;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;
  onPressedButton(BuildContext context) {
    _isPressed = !_isPressed;
    // widget.onPressed(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(_isPressed ? 0.15 : 0.28),
            blurRadius: _isPressed ? 8 : 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Center(
          child: Text(
            widget.text,
            style: AppTheme.darkTheme.textTheme.titleSmall!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xff1A1408),
            ),
          ),
        ),
      ),
    );
  }
}
