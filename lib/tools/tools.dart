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

    await _launchWhatsApp(phoneNumber, message);
  }

  static Future<void> sendSimpleWhatsAppMessage(
    String message,
  ) async {
    var phoneNumber = "+17862961703";
    await _launchWhatsApp(phoneNumber, message);
  }

  // Método privado para manejar el lanzamiento de forma segura en cualquier plataforma
  static Future<void> _launchWhatsApp(String phoneNumber, String message) async {
    final encodedMessage = Uri.encodeComponent(message);

    if (Platform.isAndroid) {
      final whatsappURLAndroid = Uri.parse(
        "whatsapp://send?phone=$phoneNumber&text=$encodedMessage",
      );
      
      // Si la app de WhatsApp está instalada, la abre; si no (como en BlueStacks), hace fallback a la web
      if (await canLaunchUrl(whatsappURLAndroid)) {
        await launchUrl(whatsappURLAndroid);
      } else {
        final whatsappURLWeb = Uri.parse(
          "https://wa.me/$phoneNumber?text=$encodedMessage",
        );
        await launchUrl(
          whatsappURLWeb,
          mode: LaunchMode.externalApplication,
        );
      }
    } else {
      final whatsappURL = Uri.parse(
        "https://wa.me/$phoneNumber?text=$encodedMessage",
      );
      await launchUrl(
        whatsappURL,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}