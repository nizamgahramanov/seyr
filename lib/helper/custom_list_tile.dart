import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_light_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    this.data,
    this.icon,
  }) : super(key: key);
  final String title;
  final String? data;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
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
              if(data!=null)
              AppLightText(
                spacing: 16,
                text: data!,
                // text:
                // '${snapshot.data!.firstName!} ${snapshot.data!.lastName!}',
                size: 13,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          if(icon!=null)
            icon!
        ],
      ),
    );
  }
}
