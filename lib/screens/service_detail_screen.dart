import 'package:flutter/material.dart';
import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/widgets/base/app_network_image.dart';

import 'package:easy_life_club/models/other_service.dart';
import '../providers/providers.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final List otherServicesData = servicesProvider.otherServicesItems is List
        ? servicesProvider.otherServicesItems
        : [];

    final String title =
        servicesProvider.otherServiceInfo['title'] ?? 'SERVICE';
    final String? image = servicesProvider.otherServiceInfo['image'];

    return Scaffold(
      backgroundColor: AppTheme.baseColor,
      appBar: CustomAppBar(
        title: title,
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null && image.isNotEmpty)
                    SizedBox(
                      height: 170,
                      width: double.infinity,
                      child: Image(
                        image: appImageProvider(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ...List.generate(
                          otherServicesData.length,
                          (index) => CustomServiceCard(
                            OtherService.fromJson(otherServicesData[index]),
                          ),
                        ),
                        otherServicesData.isEmpty
                            ? const ToastNotification(
                                message: 'There are no services to show',
                                warning: true,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}