import 'package:easy_life_club/models/other_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/providers.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class SubServiceDetailScreen extends StatefulWidget {
  const SubServiceDetailScreen({Key? key}) : super(key: key);

  @override
  State<SubServiceDetailScreen> createState() => _SubServiceDetailScreenState();
}

class _SubServiceDetailScreenState extends State<SubServiceDetailScreen> {
  final PageController _controller = PageController(viewportFraction: 1);
  List<Widget> productImages = [];

  @override
  Widget build(BuildContext context) {
    final ServicesProvider provider =
        Provider.of<ServicesProvider>(context, listen: false);
    final OtherService service = provider.otherServiceInfo['selected'];

    if (productImages.isEmpty) {
      productImages = List.generate(
        service.images.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              provider.selectedProductImageIndex = index;
              Navigator.pushNamed(context, 'full_screen_images');
            },
            child: Container(
              width: MediaQuery.of(context).size.width, // Full width of the screen
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), // Adjust border radius as needed
                image: DecorationImage(
                  image: NetworkImage(service.images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      appBar: CustomAppBar(
        title: service.name,
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            ListView(
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: PageView(
                    allowImplicitScrolling: true,
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    children: productImages,
                  ),
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: productImages.length,
                    onDotClicked: (i) => _controller.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    ),
                    effect: WormEffect(
                      dotHeight: 6,
                      dotWidth: 14,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        service.description!,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (service.details != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              service.details!,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () =>
                            redirectToWhatsapp(context, service.name),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          backgroundColor: const Color(0xff1A1E23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 20,
                        ),
                        child: const Text(
                          'Contact now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
