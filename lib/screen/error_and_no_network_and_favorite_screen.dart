import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seyr/helper/app_light_text.dart';

import '../helper/app_colors.dart';

class ErrorAndNoNetworkAndFavoriteScreen extends StatelessWidget {
  const ErrorAndNoNetworkAndFavoriteScreen({
    Key? key,
    required this.text,
    required this.path,
    this.width,
    this.height,
  }) : super(key: key);

  final String text;
  final String path;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  path,
                  width: width,
                  height: height,
                ),
                AppLightText(
                  spacing: 0,
                  text: text,
                  size: 18,
                  color: AppColors.blackColor54,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
