import 'package:flutter/material.dart';

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
    final otherServicesData = servicesProvider.otherServicesItems;

    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      appBar: CustomAppBar(
        title: servicesProvider.otherServiceInfo['title'],
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
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Image(
                      image: NetworkImage(
                        servicesProvider.otherServiceInfo['image'],
                      ),
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
