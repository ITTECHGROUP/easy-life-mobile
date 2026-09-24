import 'package:easy_life_club/widgets/custom_rounded_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialNetworksWidget extends StatelessWidget {
  const SocialNetworksWidget({super.key});
                          
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomRoundedIconButton(
          link: 'https://www.instagram.com/easylifeclubmiami',
          backgroundColor: const Color(0xff39424D),
          icon: FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.black.withOpacity(0.75),
            size: 26,
          ),
        ),
        const SizedBox(width: 20),
        CustomRoundedIconButton(
          link: 'https://www.youtube.com/@easylifeclub9110',
          backgroundColor: const Color(0xff39424D),
          icon: FaIcon(
            FontAwesomeIcons.youtube,
            color: Colors.black.withOpacity(0.75),
            size: 26,
          ),
        ),
      ],
    );
  }
}