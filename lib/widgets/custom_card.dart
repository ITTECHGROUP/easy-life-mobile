import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/widgets/base/app_network_image.dart';
import 'package:easy_life_club/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.title,
    this.imgURL,
    this.videoUrl,
    this.price,
    this.route,
    this.tag,
    this.description,
    this.topSpeed,
    this.accelerationTime,
    this.hp,
    this.capacityLiters,
    this.capacityCc,
    this.motorType,
    this.isApartment = false,
    this.duration = 1,
  }) : super(key: key);

  final String? title;
  final String? price;
  final String? imgURL;
  final String? videoUrl;
  final String? route;
  final String? description;
  final String? tag;
  final int? topSpeed;
  final double? accelerationTime;
  final int? hp;
  final double? capacityLiters;
  final double? capacityCc;
  final String? motorType;
  final bool isApartment;
  final int duration;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imageHeight = title != null ? 150.0 : 188.0;

    final Widget media;
    if (videoUrl != null) {
      media = SizedBox(height: imageHeight, width: double.infinity, child: VideoPlayerWidget(videoUrl: videoUrl!));
    } else {
      media = AppNetworkImage(imgURL ?? '', height: imageHeight, width: double.infinity);
    }

    return Container(
      padding: const EdgeInsets.all(6),
      width: width - 10,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: AppTheme.glass(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(17),
              bottom: Radius.circular(title != null ? 6 : 17),
            ),
            child: Stack(
              children: [
                media,
                if (title != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppTheme.surface.withOpacity(0.55)],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: price != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: Colors.white),
                          textAlign: price != null ? TextAlign.left : TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isApartment)
                          Text(
                            'Prices starting at',
                            style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondary),
                          ),
                      ],
                    ),
                  ),
                  if (price != null) ...[
                    const SizedBox(width: 10),
                    Text(
                      '\$ $price',
                      style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.gold),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
