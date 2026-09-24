import 'package:easy_life_club/providers/providers.dart';
import 'package:easy_life_club/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final List otherServices = servicesProvider.otherServices;
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: const CustomAppBar(
        title: "SERVICES",
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: otherServices.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LoadingDialog(
                          message: "Loading services...",
                        );
                      },
                    );
                    final navigator = Navigator.of(context);

                    await servicesProvider.getOtherServicesListById(
                      otherServices[index]["id"],
                    );

                    servicesProvider.otherServiceInfo['image'] =
                        otherServices[index]["image"];

                    servicesProvider.otherServiceInfo['title'] =
                        otherServices[index]["name"].toString().toUpperCase();

                    servicesProvider.otherServiceInfo['description'] =
                        otherServices[index]['description'];

                    servicesProvider.otherServiceInfo['images'] =
                        otherServices[index]['images'];

                    navigator.popAndPushNamed('service_detail');
                  },
                  child: CustomCard(
                    imgURL: otherServices[index]["image"],
                    title:
                        otherServices[index]["name"].toString().toUpperCase(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
