import 'package:flutter/material.dart';
import 'package:easy_life_club/constants/features.dart';
import 'package:easy_life_club/widgets/marketing_opt_in_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import '../theme/app_theme.dart';
import '../tools/tools.dart';
import '../widgets/base/base.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final islogged = authProvider.isLogged;

    return Scaffold(
      backgroundColor: AppTheme.baseColor,
      appBar: const CustomAppBar(
        title: "SETTINGS",
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 6,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("faq"),
                      child: const _SettingsOption(
                        title: "FAQ",
                        subtitle:
                            "Find answers to common questions about using EasyLife.",
                        leadingIcon: "assets/icons/question_mark_icon.svg",
                        trailingIcon: Icons.arrow_forward_ios_rounded,
                      ),
                    ),
                    if (kEmailMarketingEnabled)
                      GestureDetector(
                        onTap: () => showMarketingOptIn(context),
                        child: const _SettingsOption(
                          title: "Email news & offers",
                          subtitle:
                              "Get exclusive offers, new arrivals and private events by email. Subscribe or unsubscribe anytime.",
                          leadingIcon: "assets/icons/browser_icon.svg",
                          trailingIcon: Icons.arrow_forward_ios_rounded,
                        ),
                      ),
                    GestureDetector(
                      onTap: () => Tools.launchInBrowser(
                        Uri.parse("https://easylife-club.com/"),
                      ),
                      child: const _SettingsOption(
                        title: "Visit website",
                        subtitle:
                            "Discover Easy Life Club at easylife-club.com.",
                        leadingIcon: "assets/icons/browser_icon.svg",
                        trailingIcon: Icons.arrow_forward_ios_rounded,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: true,
                          barrierColor: Colors.black54,
                          context: context,
                          builder: (context) => TermsAndConditions(
                            onAccept: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                      child: const _SettingsOption(
                        title: "Terms and conditions",
                        subtitle:
                            "Read our terms of service and privacy policy.",
                        leadingIcon:
                            "assets/icons/terms_and_conditions_icon.svg",
                        trailingIcon: Icons.arrow_forward_ios_rounded,
                      ),
                    ),
                    islogged
                        ? GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "profile"),
                            child: const _SettingsOption(
                              title: "User Information",
                              subtitle:
                                  "Your membership, benefits and profile details.",
                              leadingIcon: "assets/icons/user_icon.svg",
                              trailingIcon: Icons.arrow_forward_ios_rounded,
                            ),
                          )
                        : Container(),
                    islogged
                        ? GestureDetector(
                            onTap: () => _closeSessionDialog(
                              context,
                              authProvider,
                            ),
                            child: const _SettingsOption(
                              title: "Logout",
                              leadingIcon: "assets/icons/logout_icon.svg",
                              trailingIcon: Icons.arrow_forward_ios_rounded,
                              danger: true,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOption extends StatefulWidget {
  const _SettingsOption({
    Key? key,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    required this.trailingIcon,
    this.danger = false,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String leadingIcon;
  final IconData trailingIcon;
  final bool danger;

  @override
  State<_SettingsOption> createState() => _SettingsOptionState();
}

class _SettingsOptionState extends State<_SettingsOption> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v && mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.danger ? AppTheme.danger : AppTheme.gold;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 140),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surface.withOpacity(0.85),
                AppTheme.surface.withOpacity(0.6),
              ],
            ),
            border:
                Border.all(color: accent.withOpacity(_pressed ? 0.7 : 0.18)),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? accent.withOpacity(0.18)
                    : Colors.black.withOpacity(0.3),
                blurRadius: _pressed ? 18 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.12),
                  border: Border.all(color: accent.withOpacity(0.45)),
                ),
                child: SvgPicture.asset(
                  widget.leadingIcon,
                  colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.danger ? AppTheme.danger : Colors.white,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle!,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.45,
                            color: AppTheme.secondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: accent.withOpacity(0.12)),
                child: Icon(widget.trailingIcon, size: 13, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _closeSessionDialog(BuildContext context, AuthProvider auth) async {
  showDialog(
    barrierDismissible: true,
    barrierColor: Colors.black54,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: AppTheme.primary,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CORREGIDO AQUÍ: Usamos FaIcon en lugar de Icon
          const FaIcon(FontAwesomeIcons.arrowRightToBracket),
          const SizedBox(height: 20),
          Text(
            "Logout",
            style: AppTheme.darkTheme.textTheme.titleSmall,
          ),
          const SizedBox(height: 20),
          Text(
            "Are you sure you want to Log out?",
            style: AppTheme.darkTheme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const PrimaryButton(
                  text: "Cancel",
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  auth.logout();
                  Navigator.pop(context);
                },
                child: const PrimaryButton(
                  text: "Logout",
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
