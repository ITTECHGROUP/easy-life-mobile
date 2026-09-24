import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_secure_storage.dart';
import '../widgets/base/base.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSecureStorage.setAppOpenedFirstTime("false");

    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Image(
                        image: AssetImage('assets/splash_logo.png'),
                        height: 60,
                      ),
                    ),
                    Text(
                      "We are dedicated to one profession service.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Image(
                      image: AssetImage('assets/onboarding/onboarding_1.png'),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "We  put our know-how to meet expectations to free you from your daily life tasks.\n Our wide range of concierge services will make your life easier and make you enter a universe of comfort.",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => navigateTo(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 80,
                        ),
                        child: PrimaryButton(
                          text: "Get started!",
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(BuildContext context) {
    Navigator.popAndPushNamed(context, "home");
  }
}
