import 'package:flutter/material.dart';
import 'package:seyr/helper/app_light_text.dart';

import '../helper/app_colors.dart';

class CustomRadioText extends StatelessWidget {
  const CustomRadioText({
    super.key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              activeColor: AppColors.primaryColorOfApp,
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            AppLightText(
              text: label,
              size: 15,
              padding: EdgeInsets.zero,
              spacing: 0,
            ),
          ],
        ),
      ),
    );
  }
}
