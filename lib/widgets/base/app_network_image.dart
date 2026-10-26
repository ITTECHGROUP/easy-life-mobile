import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Network image cached on disk (downloaded once per device) and decoded at the size it is
/// displayed, which keeps scrolling smooth and memory low even with multi-MB originals.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset = 'assets/no_image.png',
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackAsset;

  @override
  Widget build(BuildContext context) {
    if (!url.startsWith('http')) {
      return Image.asset(url.isEmpty ? fallbackAsset : url, width: width, height: height, fit: fit);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        // `width` may be double.infinity ("fill"), so only trust finite values.
        final logical = [width, constraints.maxWidth, MediaQuery.of(context).size.width]
            .firstWhere((w) => w != null && w.isFinite && w > 0, orElse: () => 400)!;
        final cacheWidth = (logical * MediaQuery.of(context).devicePixelRatio).round().clamp(200, 2000);
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          memCacheWidth: cacheWidth,
          fadeInDuration: const Duration(milliseconds: 250),
          placeholder: (_, __) => Container(width: width, height: height, color: AppTheme.surfaceHigh),
          errorWidget: (_, __, ___) => Image.asset(fallbackAsset, width: width, height: height, fit: fit),
        );
      },
    );
  }
}

/// Same caching for places that need an ImageProvider (e.g. DecorationImage).
ImageProvider appImageProvider(String url, {int width = 1000}) =>
    ResizeImage(CachedNetworkImageProvider(url), width: width, policy: ResizeImagePolicy.fit);
