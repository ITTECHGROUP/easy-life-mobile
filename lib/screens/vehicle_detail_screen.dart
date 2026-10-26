import 'package:flutter/material.dart';
import 'package:easy_life_club/widgets/base/app_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../models/vehicle_model.dart';
import '../providers/services/services_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/base/base.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final Vehicle? vehicle = servicesProvider.selectedVehicle;

    if (vehicle == null) {
      return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: const CustomAppBar(title: 'VEHICLE DETAILS', showArrowBack: true),
        body: const Center(
          child: Text('No vehicle selected', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final List<String> gallery = vehicle.images.isNotEmpty
        ? vehicle.images
        : (vehicle.image.isNotEmpty ? [vehicle.image] : [Constants.noImageURL]);

    final String displayPrice = vehicle.priceLabel.isNotEmpty
        ? (vehicle.priceLabel.startsWith('\$') ? vehicle.priceLabel : '\$${vehicle.priceLabel}')
        : '\$${vehicle.price}';

    final String descriptionText = vehicle.description is List
        ? (vehicle.description as List).join('\n')
        : vehicle.description.toString();

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: CustomAppBar(
        title: vehicle.name.toUpperCase(),
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carrusel de Imágenes
                  SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: gallery.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return AppNetworkImage(
                              gallery[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        if (gallery.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                gallery.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentImageIndex == index ? 10 : 7,
                                  height: _currentImageIndex == index ? 10 : 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? Colors.amber
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Título, Precio y Badge
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                vehicle.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (vehicle.featured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'FEATURED',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          displayPrice,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Divider(color: Colors.white24),
                  ),

                  // Especificaciones / Ficha Técnica (Seguras con los tipos String de Vehicle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SPECIFICATIONS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 2.8,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            if (vehicle.year.toString().isNotEmpty)
                              _SpecTile(title: 'Year', value: vehicle.year.toString()),
                            if (vehicle.mileage.toString().isNotEmpty)
                              _SpecTile(
                                title: 'Mileage',
                                value: '${vehicle.mileage} miles',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (descriptionText.trim().isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Divider(color: Colors.white24),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DESCRIPTION',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            descriptionText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Botón Inferior "I'M INTERESTED"
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final String msg = Uri.encodeComponent(
                      'Hi! I am interested in the vehicle: ${vehicle.name} ($displayPrice).',
                    );
                    final Uri whatsappUrl =
                        Uri.parse('https://wa.me/?text=$msg');
                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text(
                    'I\'M INTERESTED',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final String title;
  final String value;

  const _SpecTile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}