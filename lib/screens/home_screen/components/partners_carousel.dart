import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnersCarousel extends StatelessWidget {
  const PartnersCarousel({super.key});

  List<String> _loadAssetImages() {
    return const [
      'assets/partners/1.png',
      'assets/partners/3.png',
      'assets/partners/5.png',
      'assets/partners/7.png',
      'assets/partners/9.png',
      'assets/partners/10.png',
      'assets/partners/11.png',
      'assets/partners/12.png',
      'assets/partners/13.PNG',
      'assets/partners/14.PNG',
      'assets/partners/15.PNG',
      'assets/partners/16.png',
      'assets/partners/17.png',
    ];
  }

  Future<void> _launchEasyLifeCarsUrl() async {
    final Uri url = Uri.parse('https://easylife-auto-find.lovable.app/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = _loadAssetImages();

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'OUR PARTNERS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 30,
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: imagePaths.length,
          options: CarouselOptions(
            aspectRatio: 0.65,
            viewportFraction: 0.65,
            height: 170,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            enlargeCenterPage: true,
            enlargeFactor: 0,
          ),
          itemBuilder: (context, index, _) {
            final imagePath = imagePaths[index];
            final isEasyLifeCars = imagePath == 'assets/partners/17.png';

            Widget imageWidget = Image.asset(
              imagePath,
              fit: BoxFit.contain,
            );

            if (isEasyLifeCars) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _launchEasyLifeCarsUrl,
                  child: imageWidget,
                ),
              );
            }

            return imageWidget;
          },
        ),
      ],
    );
  }
}