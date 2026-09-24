import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../theme/app_theme.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: AppTheme.primary,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          // Rounded loading indicator
          const SizedBox(height: 20),
          const _CustomRipplesLoader(),
          // const CircularProgressIndicator(
          //   color: AppTheme.secondary,
          // ),
        ],
      ),
    );
  }
}

class _CustomRipplesLoader extends StatelessWidget {
  const _CustomRipplesLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SpinKitPulse(
          color: Colors.white,
          duration: Duration(milliseconds: 1800),
        ),
        SpinKitPulse(
          color: Colors.white,
          duration: Duration(milliseconds: 1200),
        ),
        SpinKitPulse(
          color: Colors.white,
          duration: Duration(milliseconds: 600),
        ),
      ],
    );
  }
}
