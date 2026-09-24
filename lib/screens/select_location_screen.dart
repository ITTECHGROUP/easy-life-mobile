import 'package:easy_life_club/models/location.dart';
import 'package:easy_life_club/widgets/base/background.dart';
import 'package:easy_life_club/widgets/base/custom_app_bar.dart';
import 'package:easy_life_club/widgets/base/loading_dialog.dart';
import 'package:easy_life_club/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'package:easy_life_club/providers/providers.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key, required this.serviceId});

  final int serviceId;

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: servicesProvider.screeTitle.toUpperCase(),
        showArrowBack: true,
      ),
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: FutureBuilder(
              future: servicesProvider.getLocations(serviceId),
              builder: (__, AsyncSnapshot<List<Location>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingDialog(message: 'Loading locations...');
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    snapshot.data!.length,
                    (index) {
                      Location location = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () async {
                            servicesProvider.resetProducts();

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const LoadingDialog(message: 'Loading villas...');
                                },);

                            await servicesProvider.getProductsDetailFromApi(
                              serviceId,
                              location: location.id,
                            );

                            Navigator.pop(context);

                            if (context.mounted) {
                              Navigator.pushNamed(
                                context,
                                'products',
                                arguments: {'subtitle': ' - ${location.name}'},
                              );
                            }
                          },
                          child: CustomCard(
                            imgURL: location.image ?? 'assets/no_image.png',
                            title: location.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
