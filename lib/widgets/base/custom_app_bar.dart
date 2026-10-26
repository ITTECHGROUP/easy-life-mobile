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
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: showArrowBack!
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.glass(radius: 20),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.textPrimary),
                  ),
                ),
              ),
            )
          : null,
      actions: icon != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "settings"),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.glass(radius: 20),
                    child: Icon(icon!, size: 20, color: AppTheme.gold),
                  ),
                ),
              )
            ]
          : null,
    );
  }
}
