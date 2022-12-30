import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';

import '../service/network_service.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;
  String buttonText;
  Color? buttonColor;
  double borderRadius;
  Color borderColor;
  double horizontalMargin;
  double verticalMargin;
  Color? textColor;
  Widget? icon;
  double buttonTextSize;
  double height;
  EdgeInsets? textPadding;

  CustomButton(
      {Key? key,
      required this.onTap,
      required this.buttonText,
      this.buttonTextSize = 18,
      this.buttonColor,
      required this.borderRadius,
      required this.borderColor,
      this.horizontalMargin = 0.0,
      this.verticalMargin = 0.0,
      this.textColor,
      this.icon,
      this.height = 60,
      this.textPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkStatus = Provider.of<NetworkStatus>(context);
    return Container(
      height: height,
      // width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: buttonColor ?? AppColors.primaryColorOfApp,
        border: networkStatus == NetworkStatus.online
            ? Border.all(color: borderColor)
            : Border.all(color: AppColors.redAccent),
      ),
      child: InkWell(
        onTap: networkStatus == NetworkStatus.online ? onTap : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            Material(
              color: Colors.transparent,
              child: Container(
                padding: textPadding,
                child: Center(
                  child: AppLightText(
                    spacing: 2,
                    text: buttonText,
                    size: buttonTextSize,
                    color:
                        textColor == null ? AppColors.whiteColor : textColor!,
                    padding: EdgeInsets.zero,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
