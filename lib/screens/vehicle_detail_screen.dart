import 'package:flutter/material.dart';
import 'package:easy_life_club/widgets/base/app_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../models/vehicle_model.dart';
import '../providers/services/services_provider.dart';
import '../theme/app_theme.dart';
import '../tools/tools.dart';
import '../widgets/base/base.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _currentImageIndex = 0;
  bool _showAllSpecs = false;
  bool _showFullDescription = false;

  // Shown first; anything else goes behind "View all specifications" to keep the screen clean.
  static const _keyFactOrder = ['Year', 'Mileage', 'Engine', 'Horsepower', 'Transmission', 'Drivetrain'];

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final Vehicle? vehicle = servicesProvider.selectedVehicle;

    if (vehicle == null) {
      return Scaffold(
        backgroundColor: AppTheme.baseColor,
        appBar: const CustomAppBar(title: 'VEHICLE DETAILS', showArrowBack: true),
        body: const Center(
          child: Text('No vehicle selected', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final List<String> gallery = vehicle.images.isNotEmpty
        ? vehicle.images
        : (vehicle.image.isNotEmpty ? [vehicle.image] : [Constants.noImageURL]);

    final String displayPrice = vehicle.priceLabel;

    final allSpecs = <Spec>[
      if (vehicle.year.isNotEmpty) Spec('Year', vehicle.year),
      if (vehicle.mileageLabel.isNotEmpty) Spec('Mileage', vehicle.mileageLabel),
      ...vehicle.specifications.map(
        (x) => x.label == 'Horsepower' && num.tryParse(x.value) != null ? Spec(x.label, '${x.value} hp') : x,
      ),
    ];
    final keyFacts = [
      for (final label in _keyFactOrder) ...allSpecs.where((x) => x.label == label),
    ];
    final moreSpecs = allSpecs.where((x) => !_keyFactOrder.contains(x.label)).toList();

    final String descriptionText = vehicle.description is List
        ? (vehicle.description as List).join('\n')
        : vehicle.description.toString();

    return Scaffold(
      backgroundColor: AppTheme.baseColor,
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
                        // Too many dots would overflow the row: use a counter instead.
                        if (gallery.length > 12)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_currentImageIndex + 1} / ${gallery.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        else if (gallery.length > 1)
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
                                        ? AppTheme.gold
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
                                  color: AppTheme.gold,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayPrice,
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (vehicle.status != 'available')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.gold.withOpacity(0.6)),
                                ),
                                child: Text(
                                  vehicle.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.gold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.secondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                vehicle.location,
                                style: const TextStyle(color: AppTheme.secondary, fontSize: 13),
                              ),
                            ),
                          ],
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
                            for (final fact in keyFacts) _SpecTile(title: fact.label, value: fact.value),
                          ],
                        ),
                        if (moreSpecs.isNotEmpty) ...[
                          AnimatedSize(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            alignment: Alignment.topCenter,
                            child: _showAllSpecs
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [for (final spec in moreSpecs) _SpecRow(spec: spec)],
                                    ),
                                  )
                                : const SizedBox(width: double.infinity),
                          ),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => setState(() => _showAllSpecs = !_showAllSpecs),
                              icon: Icon(
                                _showAllSpecs ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: AppTheme.gold,
                              ),
                              label: Text(
                                _showAllSpecs ? 'Show less' : 'View all specifications (${moreSpecs.length})',
                                style: const TextStyle(color: AppTheme.gold),
                              ),
                            ),
                          ),
                        ],
                        if (vehicle.carfaxUrl.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.gold,
                                side: BorderSide(color: AppTheme.gold.withOpacity(0.5)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                final uri = Uri.tryParse(vehicle.carfaxUrl);
                                if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
                              },
                              icon: const Icon(Icons.open_in_new_rounded, size: 18),
                              label: const Text('View Carfax report'),
                            ),
                          ),
                        ],
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
                            maxLines: _showFullDescription ? null : 4,
                            overflow: _showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          if (descriptionText.length > 180 || '\n'.allMatches(descriptionText).length > 3)
                            TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () => setState(() => _showFullDescription = !_showFullDescription),
                              child: Text(
                                _showFullDescription ? 'Read less' : 'Read more',
                                style: const TextStyle(color: AppTheme.gold),
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
                    backgroundColor: AppTheme.gold,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Tools.sendSimpleWhatsAppMessage(
                    'Hi! I am interested in the vehicle: ${vehicle.name} ($displayPrice).',
                  ),
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

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.spec});
  final Spec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(spec.label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              spec.value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
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