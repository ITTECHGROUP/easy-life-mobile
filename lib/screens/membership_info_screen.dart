import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';

import 'package:easy_life_club/widgets/base/base.dart';
import 'package:easy_life_club/widgets/widgets.dart';

class MemberShipInfoScreen extends StatelessWidget {
  const MemberShipInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final membershipProvider = Provider.of<MembershipProvider>(
      context,
    );
    final selectedMembership = membershipProvider.selectedMembership;
    final selectedMembershipName =
        selectedMembership['name'].toString().toUpperCase();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        title: Text(
          selectedMembershipName,
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
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCard(
                    imgURL: selectedMembership["image"],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        selectedMembership["benefits"].length,
                        (index) {
                          return _MembershipItem(
                            selectedMembership["benefits"][index]['name'],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => getOneMembership(
                      context,
                      selectedMembershipName,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80.0),
                      child: PrimaryButton(
                        text: "Get one!",
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getOneMembership(BuildContext context, String membership) async {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Redirecting to Whatsapp",
      ),
    );
    Navigator.pop(context);

    var phoneNumber = "+17862961703";
    var message = "I would like to obtain a *$membership* membership";

    if (Platform.isAndroid) {
      var whatsappURLAndroid =
          "whatsapp://send?phone=$phoneNumber&text=$message";
      await launchUrl(Uri.parse(whatsappURLAndroid));
    } else {
      var whatsappURL = "https://wa.me/$phoneNumber?text=$message";
      await launchUrl(Uri.parse(whatsappURL));
    }
  }
}

class _MembershipItem extends StatelessWidget {
  const _MembershipItem(this.item);
  final String item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(image: AssetImage("assets/item_indicator.png")),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            item,
            style: AppTheme.darkTheme.textTheme.titleSmall,
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
