import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../tools/tools.dart';

class CustomRoundedIconButton extends StatelessWidget {
  const CustomRoundedIconButton({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    this.link,
  }) : super(key: key);

  final Color backgroundColor;
  final FaIcon icon;
  final String? link;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        onPressed: () {
          Tools.launchInBrowser(
            Uri.parse(link ?? 'https://easylife-club.com/'),
          );
        },
        icon: icon,
        iconSize: 30,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
