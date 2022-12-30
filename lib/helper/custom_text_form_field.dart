import 'package:flutter/material.dart';

import '../helper/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.controller,
    required this.keyboardType,
    this.onChanged,
    required this.onFieldSubmitted,
    this.onSaved,
    required this.textInputAction,
    this.suffixIcon,
    this.focusNode,
    this.obscureText = false,
    this.validator,

  }) : super(key: key);
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged? onSaved;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction:textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      focusNode: focusNode,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      obscuringCharacter: "*",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: AppColors.primaryColorOfApp,
      ),
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColorOfApp,
            width: 2,
          ),
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: AppColors.primaryColorOfApp,
        // focusColor: AppColors.primaryColorOfApp
      ),
      onSaved: onSaved,
    );
  }
}
