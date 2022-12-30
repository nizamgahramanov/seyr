import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helper/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircle;
  final ShapeBorder shapeBorder;

  const ShimmerEffect.rectangular(
      {this.width = double.infinity,
      required this.height,
      required this.isCircle})
      : shapeBorder = const RoundedRectangleBorder();
  const ShimmerEffect.circular(
      {required this.width,
      required this.height,
      required this.isCircle,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey,
      highlightColor: AppColors.grey300,
      child: Container(
        width: width,
        height: height,
        margin: isCircle
            ? const EdgeInsets.only(right: 17, left: 5, top: 5, bottom: 5)
            : EdgeInsets.zero,
        decoration: isCircle
            ? ShapeDecoration(
                color: AppColors.grey200,
                shape: shapeBorder,
              )
            : BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(15),
              ),
      ),
    );
  }
}
