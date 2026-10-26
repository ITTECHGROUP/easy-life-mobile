import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/base/base.dart';
import 'package:easy_life_club/providers/auth/auth_provider.dart';
import 'package:easy_life_club/tools/push_notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;

  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.baseColor,
      appBar: const CustomAppBar(title: 'LOGIN', showArrowBack: true),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  decoration: AppTheme.glass(radius: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Image(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.contain,
                        height: 110,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to your Easy Life membership',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondary),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: userNameTextController,
                        autofillHints: const [AutofillHints.username],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Username",
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordTextController,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => login(context, authProvider),
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () => _changeVisibility(),
                            icon: Icon(
                              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        obscureText: obscureText,
                      ),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: () => login(context, authProvider),
                        child: const PrimaryButton(text: "Log in"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeVisibility() {
    return setState(
      () {
        obscureText = !obscureText;
      },
    );
  }

  void login(BuildContext context, AuthProvider auth) async {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Login...",
      ),
    );

    await auth.login(
      userNameTextController.text,
      passwordTextController.text,
      deviceToken: await PushNotificationService.deviceToken(),
    );

    if (auth.isLogged) {
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, "profile");
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        barrierDismissible: true,
        barrierColor: Colors.black54,
        context: context,
        builder: (context) => const ToastNotification(
          message: "Error trying to login",
          error: true,
        ),
      );
    }
  }
}
