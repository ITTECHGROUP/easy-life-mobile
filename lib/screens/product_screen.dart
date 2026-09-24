import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/product.dart';
import '../providers/services/services_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/base/base.dart';
import '../widgets/custom_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, this.subtitle, this.wait = false})
      : super(key: key);
  final String? subtitle;
  final bool wait;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    void updateSelectedProduct(Product product) {
      final servicesProvider = Provider.of<ServicesProvider>(
        context,
        listen: false,
      );
      servicesProvider.setSelectedProduct(product);

      servicesProvider.serviceType == 'others'
          ? Navigator.of(context).pushNamed('service_detail')
          : Navigator.of(context).pushNamed('car_info');
    }

    final servicesProvider = Provider.of<ServicesProvider>(
      context,
      listen: true,
    );

    final List<Product> products = servicesProvider.products;

    final id = servicesProvider.selectedServiceId;
    String screenTitle = servicesProvider.screeTitle;
    final String serviceType = servicesProvider.serviceType!;

    final ScrollController controller = ScrollController();

    controller.addListener(
      () async {
        if (controller.offset > (controller.position.maxScrollExtent) &&
            !loading &&
            servicesProvider.loadMoreProducts) {
          loading = true;

          showDialog(
            barrierDismissible: true,
            barrierColor: Colors.black54,
            context: context,
            builder: (context) => const LoadingDialog(
              message: 'Loading more products...',
            ),
          );

          final navigator = Navigator.of(context);
          await servicesProvider.getProductsDetailFromApi(
            id,
            location: serviceType != 'villa' ? 0 : servicesProvider.selectedServiceId,
          );
          navigator.pop();
          loading = false;
        }
      },
    );

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: CustomAppBar(
        title: '$screenTitle${widget.subtitle ?? ""}'.toUpperCase(),
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              child: Column(
                children: [
                  serviceType == 'state' ? const _Founder() : Container(),
                  if (products.isEmpty)
                    widget.wait
                        ? const LoadingDialog(message: 'Loading...')
                        : const ToastNotification(
                            message: 'There are no products for this service',
                            error: true,
                          ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            updateSelectedProduct(products[index]);
                          },
                          child: CustomCard(
                            imgURL: products[index].images.isNotEmpty
                                ? products[index].images[0].image
                                : Constants.noImageURL,
                            title: products[index].name,
                            price: products[index].price,
                            route: 'car_info',
                            description: products[index].description,
                            isApartment: serviceType == 'aparment' ||
                                    serviceType == 'villa' ||
                                    serviceType == 'state'
                                ? true
                                : false,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Founder extends StatelessWidget {
  const _Founder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      color: AppTheme.primary,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image(
              width: MediaQuery.of(context).size.width * 0.4,
              image: const AssetImage('assets/founder.jpg'),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            '''
Founder of Easy Life Club and Licensed Real Estate Agent, with 5 years of experience, specialized in the Miami Market. He’s young, energetic and entrepreneurial.  He offers clients a first-hand perspective of the quintessential Miami Beach lifestyle.
As a quadrilingual, born in Switzerland and having lived in five (5) countries, Anthony holds an international experience and is able to assist in many fields.
Anthony believes that adding value is of paramount importance and his passion and grand capacity in Real Estate will allow and ensure that you to go through the process smoothly to acquire your dream home in Florida
''',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
