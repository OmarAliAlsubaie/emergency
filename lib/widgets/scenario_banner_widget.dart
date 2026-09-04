import 'package:flutter/material.dart';
import 'category_video_widget.dart';

class ScenarioBannerWidget extends StatelessWidget {
  final String categoryId;
  final double height;
  final BorderRadius? borderRadius;

  const ScenarioBannerWidget({
    super.key,
    required this.categoryId,
    this.height = 200,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryVideoWidget(
      categoryId: categoryId,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(20),
    );
  }
}
