import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import '../services/marketing_service.dart';
import '../theme/app_theme.dart';
import 'base/primary_button.dart';

/// Asks the member (once, or from Profile) for an email to receive news and offers.
/// Optional by design: "Not now" never blocks the app.
Future<void> showMarketingOptIn(BuildContext context) async {
  final email = await MarketingService.savedEmail();
  final consent = await MarketingService.savedConsent();
  if (!context.mounted) return;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) => _MarketingOptInSheet(initialEmail: email, initialConsent: consent),
  );
  await MarketingService.markPrompted();
}

/// Shows the opt-in once per device, a few seconds after the home screen settles,
/// and only if nothing else (e.g. the events dialog) is on top.
Future<void> maybeShowMarketingOptIn(BuildContext context) async {
  if (await MarketingService.wasPrompted()) return;
  await Future.delayed(const Duration(seconds: 4));
  if (!context.mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
  await showMarketingOptIn(context);
}

class _MarketingOptInSheet extends StatefulWidget {
  const _MarketingOptInSheet({required this.initialEmail, required this.initialConsent});
  final String initialEmail;
  final bool initialConsent;

  @override
  State<_MarketingOptInSheet> createState() => _MarketingOptInSheetState();
}

class _MarketingOptInSheetState extends State<_MarketingOptInSheet> {
  late final _email = TextEditingController(text: widget.initialEmail);
  late bool _consent = widget.initialConsent;
  // Only someone who already left an email can "save preferences" (i.e. unsubscribe).
  late final bool _wasSubscribed = widget.initialEmail.isNotEmpty;
  bool _saving = false;
  String _error = '';

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!MarketingService.isValidEmail(_email.text)) {
      setState(() => _error = 'Please enter a valid email.');
      return;
    }
    if (!_consent && !_wasSubscribed) {
      setState(() => _error = 'Please tick the box to receive our emails.');
      return;
    }
    setState(() {
      _saving = true;
      _error = '';
    });
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      await MarketingService.save(user: user, email: _email.text, consent: _consent);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(_consent ? "You're in! We'll keep you posted." : 'Preferences saved.')),
      );
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not save right now. Please try again.');
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.86),
              border: Border(top: BorderSide(color: AppTheme.gold.withOpacity(0.35))),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.gold.withOpacity(0.12),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.mail_outline_rounded, color: AppTheme.gold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stay in the loop',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get exclusive offers, new arrivals and private events from Easy Life Club.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: AppTheme.secondary),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _save(),
                    decoration: const InputDecoration(
                      hintText: 'your@email.com',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _consent = !_consent),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(value: _consent, onChanged: (v) => setState(() => _consent = v ?? false)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'I agree to receive news, offers and events from Easy Life Club by email. '
                              'I can unsubscribe anytime from my profile.',
                              style: GoogleFonts.poppins(fontSize: 12.5, height: 1.5, color: AppTheme.textPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(_error, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.danger)),
                    ),
                  const SizedBox(height: 18),
                  _saving
                      ? const SizedBox(height: 52, child: Center(child: CircularProgressIndicator()))
                      : GestureDetector(onTap: _save, child: PrimaryButton(text: _consent || !_wasSubscribed ? 'Subscribe' : 'Save preferences')),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Not now', style: GoogleFonts.poppins(color: AppTheme.secondary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
