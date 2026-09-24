import 'package:easy_life_club/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../tools/tools.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _controller = PageController(viewportFraction: 0.9);

  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final selectedProduct = servicesProvider.selectedProduct;
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final acceptedTermsAndConditions =
        calendarProvider.acceptedTermsAndConditions;
    final serviceType = servicesProvider.serviceType;

    String getShortDescription(String fullText) {
      // ignore: unnecessary_null_comparison
      if (fullText.length <= 140) {
        return fullText;
      } else {
        // ignore: unnecessary_null_comparison
        final length = fullText[140] != null ? 140 : fullText.length;
        return '${fullText.substring(0, length)}...';
      }
    }

    final shortDescription = getShortDescription(selectedProduct!.description);

    List<Widget> productImages = List.generate(
      selectedProduct.images.length,
      (index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            servicesProvider.selectedProductImageIndex = index;
            Navigator.pushNamed(context, 'full_screen_images');
          },
          child: CustomCard(
            imgURL: selectedProduct.images[index].image,
          ),
        ),
      ),
    );

    List<Widget> productVideos = List.generate(
      selectedProduct.videos.length,
      (index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: CustomCard(
            videoUrl: selectedProduct.videos[index].video,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      appBar: CustomAppBar(
        title: selectedProduct.name,
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 270,
                        width: double.infinity,
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: _controller,
                          onPageChanged: (page) {
                            setState(() {});
                          },
                          children: [
                            ...productVideos,
                            ...productImages,
                            if (productImages.isEmpty)
                              const CustomCard(
                                imgURL: Constants.noImageURL,
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: MediaQuery.of(context).size.width / 2 -
                            (selectedProduct.images.length * 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SmoothPageIndicator(
                                controller: _controller,
                                count: selectedProduct.images.length + selectedProduct.videos.length,
                                effect: WormEffect(
                                  dotHeight: 6,
                                  dotWidth: 14,
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedProduct.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            showFullDescription = !showFullDescription;
                            setState(() {});
                          },
                          child: Text.rich(
                            TextSpan(
                              text: showFullDescription
                                  ? '${selectedProduct.description} '
                                  : '$shortDescription ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              children: selectedProduct.description.length <=
                                      140
                                  ? []
                                  : <TextSpan>[
                                      TextSpan(
                                        text: showFullDescription
                                            ? 'Show less'
                                            : 'Show more',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                        ),
                                      ),
                                      // can add more TextSpans here...
                                    ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.1, 1],
                              colors: [
                                Color(0xff1A1E23),
                                Color(0xff16191E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      selectedProduct.features.data[0].name,
                                      style: AppTheme
                                          .darkTheme.textTheme.headlineMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      selectedProduct
                                          .features.data[0].description,
                                      style: AppTheme
                                          .darkTheme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      selectedProduct.features.data[1].name,
                                      style: AppTheme
                                          .darkTheme.textTheme.headlineMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      selectedProduct
                                          .features.data[1].description,
                                      style: AppTheme
                                          .darkTheme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                '''${selectedProduct.details.data[0].name}: ${selectedProduct.details.data[0].description}''',
                                style: AppTheme.darkTheme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '''${selectedProduct.details.data[1].name}: ${selectedProduct.details.data[1].description}''',
                                style: AppTheme.darkTheme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '\$ ${selectedProduct.price}',
                                style: AppTheme.darkTheme.textTheme.titleMedium!
                                    .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: serviceType == 'state'
                                        ? ''
                                        : '/ ${selectedProduct.priceType}',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodyLarge!
                                        .copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            serviceType == 'service'
                                ? GestureDetector(
                                    onTap: () async {
                                      onBookNowButton(
                                        context,
                                        acceptedTermsAndConditions,
                                        selectedProduct.id,
                                      );
                                    },
                                    child: const PrimaryButton(
                                      text: 'Book now',
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => onContactNowButton(
                                      context,
                                      acceptedTermsAndConditions,
                                      selectedProduct.name,
                                      servicesProvider.option.toString(),
                                    ),
                                    child: const PrimaryButton(
                                      text: 'Contact now',
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 40),
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

  void onBookNowButton(
    BuildContext context,
    bool acceptedTermsAndConditions,
    int productId,
  ) async {
    if (!acceptedTermsAndConditions) {
      showDialog(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) => TermsAndConditions(
          onAccept: () async {
            bookService(context, productId);
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      bookService(context, productId);
    }
  }

  void bookService(
    BuildContext context,
    int productId,
  ) async {
    final calendadarProvider = Provider.of<CalendarProvider>(
      context,
      listen: false,
    );

    if (calendadarProvider.acceptedTermsAndConditions) {
      showDialog(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) => const LoadingDialog(
          message: 'Loading...',
        ),
      );
      final CalendarProvider calendarProvider = Provider.of<CalendarProvider>(
        context,
        listen: false,
      );
      final navigator = Navigator.of(context);
      await calendarProvider.getReservationDataById(
        productId,
      );
      calendarProvider.updateCalendarReservationData();
      navigator.popAndPushNamed('calendar');
    }
  }

  void onContactNowButton(BuildContext context, bool acceptedTermsAndConditions,
      String productName, String productType,) async {
    !acceptedTermsAndConditions
        ? showDialog(
            barrierColor: Colors.black54,
            context: context,
            builder: (context) => TermsAndConditions(
              onAccept: () => Navigator.of(context).pop(),
            ),
          )
        : Tools.sendWhatsAppMessage('*$productName*', '*$productType*');
  }
}
