import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xff1A1E23),
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
                      onTap:() => Navigator.of(context).pushNamed("faq"),
                      child: const _SettingsOption(
                        title: "FAQ",
                        subtitle:
                            "Find answers to common questions about using EasyLife.",
                        leadingIcon: "assets/icons/question_mark_icon.svg",
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
                            "See information about your account, download an archive of your data, or learn about your account deactivation options.",
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
                            "Manage your account”s security and keep track of your account”s usage including apps that you have connected to your account.",
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
                                  "Anim mollit sint esse ipsum nostrud enim cillum sunt reprehenderit ex exercitation fugiat do pariatur.",
                              leadingIcon: "assets/icons/user_icon.svg",
                              trailingIcon: Icons.arrow_forward_ios_rounded,
                            ),
                          )
                        : Container(),

                    // islogged
                    //     ? GestureDetector(

                    //         child: const _SettingsOption(
                    //           title: "Logout",
                    //           leadingIcon: "assets/icons/logout_icon.svg",
                    //           trailingIcon: Icons.arrow_forward_ios_rounded,
                    //         ),
                    //       )
                    //     : Container(),

                    islogged
                        ? GestureDetector(
                            onTap: () => _closeSessionDialog(
                              context,
                              authProvider,
                            ),
                            child: Card(
                              color: const Color(0xff1A1E23),
                              elevation: 16,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black.withOpacity(0.05),
                                    width: 1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 16),
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 4.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/logout_icon.svg",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    "Logout",
                                    style:
                                        AppTheme.darkTheme.textTheme.bodyLarge,
                                  )),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment(0, 0.9),
              child: DeveloperBy(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
    Key? key,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    required this.trailingIcon,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String leadingIcon;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1A1E23),
      elevation: 16,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black.withOpacity(0.05), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: 
              SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  leadingIcon,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyLarge,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              )
            : Container(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              trailingIcon,
              size: 16,
            ),
          ],
        ),
        dense: true,
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
          const Icon(FontAwesomeIcons.arrowRightToBracket),
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