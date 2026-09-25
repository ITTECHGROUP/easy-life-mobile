import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';

class PartnersCarousel extends StatelessWidget {
  const PartnersCarousel({super.key});

  Future<List<String>> _loadAssetImages() async {
    // Load the asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter the assets that are images in the assets/partners/ directory
    // y excluimos el logo que no quieren mostrar (reemplaza 'dental_diamond' por el nombre real del archivo de la imagen)
    final imagePaths = manifestMap.keys
        .where((String key) => 
            key.startsWith('assets/partners/') && 
            !key.toLowerCase().contains('dental_diamond')) // <-- AQUÍ FILTRAS EL ITEM
        .toList();

    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _loadAssetImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading images'));
        } else {
          final imagePaths = snapshot.data!;
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'OUR PARTNERS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 30,
                child: Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),
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
                  // enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                itemBuilder: (context, index, _) {
                  return Image.asset(
                    imagePaths[index],
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}