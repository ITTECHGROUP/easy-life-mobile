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
      backgroundColor: const Color(0xff1A1E23),
      appBar: AppBar(
        title: Text(
          "LOGIN",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const Image(
                      image: AssetImage("assets/logo.png"),
                      fit: BoxFit.cover,
                      height: 130,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: userNameTextController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: "Username",
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: passwordTextController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => _changeVisibility(),
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          color: AppTheme.secondary,
                        ),
                      ),
                      obscureText: obscureText,
                    ),
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                      ),
                      child: GestureDetector(
                        onTap: () => login(context, authProvider),
                        child: const PrimaryButton(
                          text: "Log in",
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
