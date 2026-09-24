import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ToastNotification extends StatelessWidget {
  const ToastNotification({
    super.key,
    required this.message,
    this.error = false,
    this.warning = false,
    this.dismissible = true,
  });

  final String message;
  final bool error;
  final bool warning;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: const Color(0xff1A1E23),
      elevation: 0,
      content: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (dismissible)
            Positioned(
              top: -16,
              right: -16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xff1D2126),
                      Color.fromRGBO(255, 255, 255, 0.5),
                    ],
                    radius: 8,
                    center: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: warning
                    ? const Icon(
                        Icons.priority_high_rounded,
                        size: 40,
                      )
                    : Icon(
                        error ? Icons.close : Icons.check_rounded,
                        size: 60,
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
