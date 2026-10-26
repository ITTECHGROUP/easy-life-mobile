import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/widgets/base/app_network_image.dart';
import 'package:easy_life_club/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatefulWidget {
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
  State<CustomCard> createState() => _CustomCardState();
}

/// Press feedback: while a finger is down the border lights up gold and the card sinks slightly.
/// Uses a Listener so it never competes with the parent's tap handling; a drag (scroll) cancels it.
class _CustomCardState extends State<CustomCard> {
  bool _pressed = false;
  Offset? _downAt;

  void _setPressed(bool v) {
    if (_pressed != v && mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imageHeight = widget.title != null ? 150.0 : 188.0;

    final Widget media;
    if (widget.videoUrl != null) {
      media = SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: VideoPlayerWidget(videoUrl: widget.videoUrl!));
    } else {
      media = AppNetworkImage(widget.imgURL ?? '',
          height: imageHeight, width: double.infinity);
    }

    return Listener(
      onPointerDown: (e) {
        _downAt = e.position;
        _setPressed(true);
      },
      onPointerMove: (e) {
        if (_downAt != null && (e.position - _downAt!).distance > 12)
          _setPressed(false);
      },
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(6),
          width: width - 10,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: AppTheme.glass(highlighted: _pressed).copyWith(
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? AppTheme.gold.withOpacity(0.22)
                    : Colors.black.withOpacity(0.35),
                blurRadius: _pressed ? 22 : 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(17),
                  bottom: Radius.circular(widget.title != null ? 6 : 17),
                ),
                child: Stack(
                  children: [
                    media,
                    if (widget.title != null)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.surface.withOpacity(0.55)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: widget.price != null
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title!,
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: Colors.white),
                              textAlign: widget.price != null
                                  ? TextAlign.left
                                  : TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.isApartment)
                              Text(
                                'Prices starting at',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: AppTheme.secondary),
                              ),
                          ],
                        ),
                      ),
                      if (widget.price != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          '\$ ${widget.price}',
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.gold),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
