import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:easy_life_club/screens/screens.dart';

import '../utils/app_secure_storage.dart';
import '../widgets/base/base.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward(from: 0.0);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  void startTime() {
    const duration = Duration(seconds: 1);
    Future.delayed(duration, route);
  }

  Future<void> route() async {
    try {
      final String isFirstTime =
          await AppSecureStorage.getAppOpenedFirstTime() ?? '';

      if (isFirstTime == 'false') {
        navigateToHomeScreen();
      } else {
        navigateToOnboardingScreen();
      }
    } on Exception catch (e, stackTrace) {
      // Captura cualquier otro tipo de excepción genérica
      await FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'General Exception in route()');
      navigateToHomeScreen();
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void navigateToOnboardingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: FadeTransition(
                  opacity: _animation,
                  child: const Image(
                    image: AssetImage('assets/splash_logo.png'),
                    width: 160,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
