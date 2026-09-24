import 'package:flutter/material.dart';

import 'package:easy_life_club/models/other_service.dart';
import 'package:easy_life_club/providers/providers.dart';
import 'package:easy_life_club/tools/tools.dart';
import 'package:easy_life_club/widgets/base/loading_dialog.dart';

class CustomServiceCard extends StatelessWidget {
  const CustomServiceCard(this.service, {Key? key}) : super(key: key);

  final OtherService service;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: const Color(0xff16191E),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(service.images.first),
                width: 150,
                height: 100,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (service.details != 'none')
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.person_outline_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        service.details!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: service.description == null
                      ? () => redirectToWhatsapp(context, service.name)
                      : () {
                          final provider = Provider.of<ServicesProvider>(
                            context,
                            listen: false,
                          );
                          provider.otherServiceInfo['selected'] = service;
                          provider.selectedProduct = null;
                          Navigator.of(context).pushNamed('sub_service_detail');
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    backgroundColor: const Color(0xff1A1E23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 20,
                  ),
                  child: Text(
                    service.description == null ? 'Contact now' : 'See details',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void redirectToWhatsapp(BuildContext context, String title) {
  showDialog(
    barrierDismissible: true,
    barrierColor: Colors.black54,
    context: context,
    builder: (context) =>
        const LoadingDialog(message: 'Redirecting to WhatsApp...'),
  );

  Navigator.pop(context);

  Tools.sendSimpleWhatsAppMessage(
      'Thank you for trusting Easy Life Club! The *$title* will soon be yours. '
      'In order to complete the experience, we have to set up the date '
      'of the given service and conclude with  the payment stage.');
}
