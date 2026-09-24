import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showArrowBack = false,
    this.icon,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final bool? showArrowBack;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0x11000000),
      elevation: 0,
      leading: showArrowBack!
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppTheme.secondary,
              ),
            )
          : null,
      actions: icon != null
          ? [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, "settings"),
                icon: Icon(
                  icon!,
                  color: const Color(
                    0xff39424C,
                  ),
                ),
              )
            ]
          : null,
    );
  }
}
