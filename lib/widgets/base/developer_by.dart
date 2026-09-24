import 'package:flutter/material.dart';

import '../../tools/tools.dart';

class DeveloperBy extends StatelessWidget {
  const DeveloperBy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Developed by"),
        TextButton(
          onPressed: () => Tools.launchInBrowser(
            Uri.parse("https://www.it-techgroup.com/"),
          ),
          child: const Text(
            "IT-TECHGROUP",
          ),
        )
      ],
    );
  }
}
