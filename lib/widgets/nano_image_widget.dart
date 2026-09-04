import 'package:flutter/material.dart';
import '../core/constants/nano_banana_assets.dart';

class NanoImageWidget extends StatelessWidget {
  final String imageSource;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadiusGeometry? borderRadius;

  const NanoImageWidget({
    super.key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final pathOrUrl = NanoBananaAssets.getUrlForAsset(imageSource);

    Widget imageWidget;

    if (pathOrUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        pathOrUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (ctx, err, stack) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFF006C35).withOpacity(0.12),
            child: const Icon(Icons.broken_image, color: Color(0xFF006C35)),
          );
        },
      );
    } else {
      imageWidget = Image.network(
        pathOrUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFE8F5E9),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF006C35),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFF4DB6AC),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          );
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
