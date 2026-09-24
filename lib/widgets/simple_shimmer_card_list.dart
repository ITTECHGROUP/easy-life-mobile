import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleShimmerCardList extends StatelessWidget {
  const SimpleShimmerCardList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(3, (index) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor:
                    const Color(0xFF22262B).withOpacity(0.8).withAlpha(150),
                highlightColor: const Color(0xFF22262B),
                direction: ShimmerDirection.ltr,
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  margin: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color: Colors.black.withOpacity(1),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor:
                    const Color(0xFF22262B).withOpacity(0.8).withAlpha(150),
                highlightColor: const Color(0xFF22262B),
                direction: ShimmerDirection.ltr,
                child: Container(
                  width: double.infinity,
                  height: 30.0,
                  margin: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color: Colors.black.withOpacity(1),
                  ),
                ),
              ),
            ],
          );
        })
      ],
    );
  }
}
