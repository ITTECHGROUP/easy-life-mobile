import 'dart:io';

import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/widgets/widgets.dart';
// import 'package:easy_life_club/widgets/base/background.dart';
// import 'package:easy_life_club/widgets/base/primary_button.dart';
// import 'package:easy_life_club/widgets/base/loading_dialog.dart';
// import 'package:easy_life_club/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';
import '../widgets/base/base.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final islogged = authProvider.isLogged;

    final membershipProvider = Provider.of<MembershipProvider>(context);
    final memberships = membershipProvider.memberships;

    List<Widget> membershipItems = List.generate(
      memberships.length,
      (index) {
        if (memberships[index]['name'] == 'no_show_membership') {
          return Container();
        } else {
          return GestureDetector(
            onTap: () async {
              final navigator = Navigator.of(context);
              await membershipProvider
                  .setSelectedMembership(memberships[index]);
              await membershipProvider.getMembershipDetailFromAPI(
                membershipProvider.selectedMembership["id"],
              );
              navigator.pushNamed("membership_info");
            },
            child: CustomCard(
              imgURL: memberships[index]['image'],
              title: memberships[index]['name'].toUpperCase(),
              route: "membership_info",
              tag: memberships[index]['name'],
            ),
          );
        }
      },
    );

    return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: AppBar(
          title: Text(
            "MEMBERSHIP",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.secondary,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0x11000000),
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              const Background(),
              memberships.isEmpty
                  // ? const LoadingDialog(
                  //     message: "Loading Memberships...",
                  //   )
                  ? const SimpleShimmerCardList()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          !islogged
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 60,
                                    horizontal: 60,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => navigateTo(context),
                                    child: const PrimaryButton(
                                      text: "Login",
                                    ),
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 60,
                                    horizontal: 60,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .pushNamed("profile"),
                                    child: const PrimaryButton(
                                      text: "Go to profile",
                                    ),
                                  ),
                                ),
                          ...membershipItems,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 60,
                              horizontal: 60,
                            ),
                            child: GestureDetector(
                              onTap: () => getOneMembership(context),
                              child: const PrimaryButton(
                                text: "Get one!",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ));
  }

  void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, "login");
  }

  void getOneMembership(BuildContext context) async {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Redirecting to Whatsapp",
      ),
    );

    var phoneNumber = "+17862961703";
    var message = "I would like to obtain a membership";
    final navigator = Navigator.of(context);
    if (Platform.isAndroid) {
      var whatsappURLAndroid =
          "whatsapp://send?phone=$phoneNumber&text=$message";
      await launchUrl(Uri.parse(whatsappURLAndroid));
    } else {
      var whatsappURL = "https://wa.me/$phoneNumber?text=$message";
      await launchUrl(Uri.parse(whatsappURL));
    }
    navigator.pop();
  }
}
