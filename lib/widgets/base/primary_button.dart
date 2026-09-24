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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: !_isPressed ? 50 : 50,
      // width: !_isPressed ? 148 : 150,
      decoration: BoxDecoration(
        // gradient color
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(209, 20, 20, 20),
            AppTheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: !_isPressed
            ? const [
                BoxShadow(
                  color: Color.fromARGB(106, 0, 0, 0),
                  offset: Offset(3, 6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Color.fromARGB(108, 54, 54, 54),
                  offset: Offset(-3, -3),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : [
                const BoxShadow(
                  color: Color.fromARGB(185, 22, 22, 22),
                  offset: Offset(3, 3),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Center(
          child: Text(
            widget.text,
            style:
                AppTheme.darkTheme.textTheme.titleSmall!.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
