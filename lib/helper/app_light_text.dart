import 'package:flutter/material.dart';
import 'package:seyr/helper/app_colors.dart';

class AppLightText extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  final bool isShowIcon;
  final Widget? icon;
  final Alignment alignment;
  final EdgeInsets padding;
  final double spacing;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  AppLightText({
    Key? key,
    this.size = 16,
    required this.text,
    this.color = AppColors.blackColor38,
    this.isShowIcon = false,
    this.icon,
    this.alignment = Alignment.centerLeft,
    required this.padding,
    this.spacing=0,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.center
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      // color: Colors.amberAccent,
      child: Align(
        alignment: alignment,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing,
          children: [
            if (isShowIcon) icon!,
            Text(
              textAlign: textAlign,
              overflow: TextOverflow.fade,
              text,
              style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: fontWeight,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
