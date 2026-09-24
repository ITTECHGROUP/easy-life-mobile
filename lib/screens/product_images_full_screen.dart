import 'package:easy_life_club/models/product.dart';
import 'package:easy_life_club/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../providers/providers.dart';

class ProductImagesFullScreen extends StatefulWidget {
  const ProductImagesFullScreen({super.key});

  @override
  State<ProductImagesFullScreen> createState() =>
      _ProductImagesFullScreenState();
}

class _ProductImagesFullScreenState extends State<ProductImagesFullScreen>
    with SingleTickerProviderStateMixin {
  late TransformationController controller = TransformationController();
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final images = servicesProvider.selectedProduct?.images ??
        servicesProvider.otherServiceInfo['selected'].images;
    final index = servicesProvider.selectedProductImageIndex;

    List<Widget> imageList = List.generate(
      images.length,
      (index) => Center(
        child: InteractiveViewer(
          transformationController: controller,
          onInteractionEnd: (details) {
            resetAnimation();
          },
          clipBehavior: Clip.none,
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(80),
          child: FadeInImage(
            placeholder: const AssetImage('assets/loading_indicator.gif'),
            image: NetworkImage(
              images[index] is ProductImage
                  ? images[index].image
                  : images[index],
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppTheme.primary,
          ),
        ),
        PageView(
          physics: const BouncingScrollPhysics(),
          controller: PageController(initialPage: index),
          children: imageList,
        ),
        Positioned(
            top: 80,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
      ],
    ));
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    );
    animationController.forward(from: 0);
  }
}
