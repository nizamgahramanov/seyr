import 'package:flutter/material.dart';

import 'app_colors.dart';

class CustomIconText extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  final Widget icon;
  final double spacing;
  final bool isIconFirst;
  final MainAxisAlignment? mainAxisAlignment;
  final FontWeight fontWeight;
  CustomIconText({
    Key? key,
    this.size = 16,
    required this.text,
    this.color = AppColors.blackColor38,
    required this.icon,
    required this.spacing,
    required this.isIconFirst,
    this.mainAxisAlignment,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment == null
          ? MainAxisAlignment.start
          : mainAxisAlignment!,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isIconFirst) icon,
        if (isIconFirst)
          SizedBox(
            width: spacing,
          ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: fontWeight,
            fontFamily: 'Montserrat',
          ),
        ),
        if (!isIconFirst)
          SizedBox(
            width: spacing,
          ),
        if (!isIconFirst) icon,
      ],
    );
  }
}
