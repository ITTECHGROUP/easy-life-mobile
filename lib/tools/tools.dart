import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Tools {
  static const String appName = "Easy Life Club";

  static Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendWhatsAppMessage(
    String productName,
    String productType,
  ) async {
    var phoneNumber = "+17862961703";

    var message = """Thank you for trusting Easy Life Club!

The $productName ($productType) will soon be yours. 
In order to complete the experience, we have to conclude with the payment stage.""";

    if (Platform.isAndroid) {
      var whatsappURLAndroid =
          "whatsapp://send?phone=$phoneNumber&text=$message";
      await launchUrl(Uri.parse(whatsappURLAndroid));
    } else {
      var whatsappURL = "https://wa.me/$phoneNumber?text=$message";
      await launchUrl(Uri.parse(whatsappURL));
    }
  }

  static Future<void> sendSimpleWhatsAppMessage(
    String message,
  ) async {
    var phoneNumber = "+17862961703";

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
