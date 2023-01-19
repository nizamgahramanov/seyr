import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_light_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {Key? key,
      required this.title,
      this.data,
      this.icon,
      this.isDividerShow = true,
      this.onTapFunction})
      : super(key: key);
  final String title;
  final String? data;
  final bool isDividerShow;
  final Widget? icon;
  final VoidCallback? onTapFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLightText(
                          spacing: 16,
                          text: title,
                          size: 15,
                          color: AppColors.blackColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          padding: EdgeInsets.zero,
                        ),
                        if (data != null)
                          AppLightText(
                            spacing: 16,
                            text: data!,
                            size: 13,
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                    if (icon != null) icon!
                  ],
                ),
              ],
            ),
          ),
          if (isDividerShow)
            const Divider(
              height: 1,
              color: AppColors.primaryColorOfApp,
            ),
        ],
      ),
    );
  }
}
