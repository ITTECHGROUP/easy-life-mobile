import 'package:flutter/material.dart';

import '../screens/screens.dart';
import 'package:easy_life_club/screens/sub_service_detail_screen.dart';

class AppRoutes {
  static const initialRoute = 'splash';

  static Map<String, Widget Function(BuildContext)> routes = {
    initialRoute: (BuildContext context) => const SplashScreen(),
    'calendar': (BuildContext context) => const CalendarScreen(),
    'car_info': (BuildContext context) => const ProductDetailScreen(),
    'products': (BuildContext context) {
      Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
      String? subtitle = args?['subtitle'];
      bool wait = args?['wait'] ?? false;
      return ProductScreen(subtitle: subtitle, wait: wait);
    },
    'home': (BuildContext context) => const HomeScreen(),
    'login': (BuildContext context) => const LoginScreen(),
    'members': (BuildContext context) => const MembersScreen(),
    'membership_info': (BuildContext context) => const MemberShipInfoScreen(),
    'real_state': (BuildContext context) => const RealStateScreen(),
    'service_detail': (BuildContext context) => const ServiceDetailScreen(),
    'sub_service_detail': (BuildContext context) =>
        const SubServiceDetailScreen(),
    'services': (BuildContext context) => const ServicesScreen(),
    'settings': (BuildContext context) => const SettingsScreen(),
    'profile': (BuildContext context) => const ProfileScreen(),
    'onboarding': (BuildContext context) => const OnboardingScreen(),
    'full_screen_images': (BuildContext context) =>
        const ProductImagesFullScreen(),
    'faq': (BuildContext context) => const FAQScreen(),
  };

  // static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  //   return MaterialPageRoute(
  //     builder: (context) => const NotFoundPage(),
  //   );
  // }
}
