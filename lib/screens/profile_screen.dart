import 'package:flutter/material.dart';
import 'package:easy_life_club/constants/features.dart';
import 'package:easy_life_club/services/marketing_service.dart';
import 'package:easy_life_club/widgets/marketing_opt_in_sheet.dart';

import '../constants/constants.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../tools/tools.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final commentTextController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
  late Map user;
  late MembershipProvider membershipProvider;
  late List benefits;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.user;

    // todo: Work whit this to render lineal progress indicator
    benefits = authProvider.userBenefits;
    // final usedBenefits = authProvider.getUsedBenefitsByUser(user["id"]);

    membershipProvider =
        Provider.of<MembershipProvider>(context, listen: false);

    membershipProvider.getMembershipDetailFromAPI(user['membership']);
  }

  @override
  Widget build(BuildContext context) {
    // final selectedMembership = membershipProvider.selectedMembership;

    // final selectedMembershipName =
    //     selectedMembership['name'].toString().toUpperCase();

    return Scaffold(
      backgroundColor: AppTheme.baseColor,
      appBar: const CustomAppBar(
        title: 'PROFILE',
        // selectedServiceInfo.serviceTitle
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${user["username"] ?? ''}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // todo: get membership info from backend and display it here
                  CustomCard(
                    imgURL: membershipProvider.selectedMembership['image'] ??
                        Constants.noImageURL,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        benefits.length,
                        (index) {
                          final String title = benefits[index]['name'];
                          return _ProgressIndicator(
                            title: title,
                            used: benefits[index]['used'] as int,
                            max: benefits[index]['max_uses'] as int,
                          );
                        },
                      ),
                    ),
                  ),
                  // todo: end of membership info
                  if (kEmailMarketingEnabled) ...[
                    const SizedBox(height: 24),
                    const _EmailUpdatesTile(),
                  ],

                  const SizedBox(height: 40),
                  const _CommentField(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => sendComment(user['id']),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: AppTheme.textPrimary,
                          ),
                          child: const Text('Send Comment'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => onPressedButton(context),
                        child: const PrimaryButton(
                          text: 'Request shipping',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendComment(int userId) async {
    final commentProvider = Provider.of<CommentProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (commentTextController.text != '') {
      final error = await commentProvider.postComment(
        commentTextController.text,
        userId.toString(),
        token,
      );
      if (!mounted) return;
      !error
          ? showDialog(
              barrierDismissible: true,
              barrierColor: Colors.black54,
              context: context,
              builder: (context) => const ToastNotification(
                message: 'Message sent',
              ),
            )
          : showDialog(
              barrierDismissible: true,
              barrierColor: Colors.black54,
              context: context,
              builder: (context) => const ToastNotification(
                message: 'Error sending message',
                error: true,
              ),
            );
    }

    commentTextController.clear();
  }

  void onPressedButton(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) => const LoadingDialog(message: 'Requesting Shipping'),
    );

    Navigator.of(context).pop();

    Tools.sendSimpleWhatsAppMessage('Hi! I would like to request shipping');
  }
}

class _CommentField extends StatelessWidget {
  const _CommentField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(20),
      child: TextField(
        controller: commentTextController,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Leave us a comment...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppTheme.secondary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    Key? key,
    required this.title,
    required this.max,
    required this.used,
  }) : super(key: key);

  final String title;
  final int max;
  final int used;

  @override
  Widget build(BuildContext context) {
    final int percentage = ((used / max) * 100).floor();
    final progressImage = percentage - percentage % 10;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            width: MediaQuery.of(context).size.width * 0.50,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage(
                  'assets/app/progress_bars/$progressImage.png',
                ),
                width: 120,
              ),
              Text(
                '$used/$max',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/// Profile entry to subscribe/unsubscribe from email news and offers.
class _EmailUpdatesTile extends StatefulWidget {
  const _EmailUpdatesTile();

  @override
  State<_EmailUpdatesTile> createState() => _EmailUpdatesTileState();
}

class _EmailUpdatesTileState extends State<_EmailUpdatesTile> {
  String email = '';
  bool consent = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final e = await MarketingService.savedEmail();
    final c = await MarketingService.savedConsent();
    if (mounted) setState(() {
      email = e;
      consent = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await showMarketingOptIn(context);
          _load();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.glass(radius: 20, highlighted: consent),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.gold.withOpacity(0.12)),
                child: const Icon(Icons.mail_outline_rounded, color: AppTheme.gold),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email news & offers', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      consent ? 'Subscribed · $email' : 'Not subscribed · tap to join',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, color: AppTheme.secondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
