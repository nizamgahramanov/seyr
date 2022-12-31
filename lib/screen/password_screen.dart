import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/custom_icon_text.dart';
import 'package:seyr/model/user_credentials.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/screen/user_info.dart';

import '../helper/app_colors.dart';
import '../helper/app_light_text.dart';
import '../helper/constants.dart';
import '../helper/custom_button.dart';

class PasswordScreen extends StatefulWidget {
  static const routeName = '/password';
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  bool _isShowContinueButton = false;
  bool _minimumPasswordLength = false;
  bool _atLeastOneNumber = false;
  bool _atLeastOneLowerCase = false;
  bool _atLeastOneUpperCase = false;
  bool _isObscure = true;

  void _saveForm() {
    FocusScope.of(context).unfocus();
    _form.currentState!.save();
  }

  void toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void checkPasswordValidations(String character) {
    if (_passwordController.text.length >= 6) {
      setState(() {
        _minimumPasswordLength = true;
      });
    } else {
      setState(() {
        _minimumPasswordLength = false;
      });
    }
    if (!RegExp(lowerCasePattern).hasMatch(_passwordController.text)) {
      setState(() {
        _atLeastOneLowerCase = false;
      });
    } else {
      setState(() {
        _atLeastOneLowerCase = true;
      });
    }
    if (!RegExp(upperCasePattern).hasMatch(_passwordController.text)) {
      setState(() {
        _atLeastOneUpperCase = false;
      });
    } else {
      setState(() {
        _atLeastOneUpperCase = true;
      });
    }
    if (!RegExp((r'\d')).hasMatch(_passwordController.text)) {
      setState(() {
        _atLeastOneNumber = false;
      });
    } else {
      setState(() {
        _atLeastOneNumber = true;
      });
    }
    if (_minimumPasswordLength &&
        _atLeastOneNumber &&
        _atLeastOneLowerCase &&
        _atLeastOneUpperCase) {
      _isShowContinueButton = true;
    } else {
      _isShowContinueButton = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    void _goNextScreen(String value) {
      if (!args['provider'] && _isShowContinueButton) {
        Navigator.pushNamed(
          context,
          UserInfo.routeName,
          arguments: UserCredentials(
            args['email'],
            value,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'please_set_password_title'.tr(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AppLightText(
              text: "${'welcome_msg'.tr()} ${args['email']}",
              padding: EdgeInsets.zero,
              textAlign: TextAlign.start,
              alignment: Alignment.topLeft,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  AppLightText(
                    text: 'password_title'.tr(),
                    size: 18,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Focus(
                    autofocus: true,
                    onFocusChange: (bool inFocus) {
                      if (inFocus) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      }
                    },
                    child: CustomTextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                      onChanged: (value) => checkPasswordValidations(value),
                      onSaved: (value) => _goNextScreen(value),
                      onFieldSubmitted: (_) => _saveForm(),
                      obscureText: _isObscure,
                      suffixIcon: GestureDetector(
                        onTap: () => toggleObscure(),
                        child: _isObscure
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomIconText(
              text: 'minimum_of_6_characters_validation'.tr(),
              color: _minimumPasswordLength
                  ? AppColors.blackColor
                  : AppColors.blackColor38,
              icon: Icon(
                Icons.check,
                color: _minimumPasswordLength
                    ? AppColors.blackColor
                    : AppColors.blackColor38,
              ),
              spacing: 10,
              isIconFirst: true,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomIconText(
              text: 'at_least_one_lower_case_validation'.tr(),
              color: _atLeastOneLowerCase
                  ? AppColors.blackColor
                  : AppColors.blackColor38,
              icon: Icon(
                Icons.check,
                color: _atLeastOneLowerCase
                    ? AppColors.blackColor
                    : AppColors.blackColor38,
              ),
              spacing: 10,
              isIconFirst: true,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomIconText(
              text: 'at_least_one_upper_case_validation'.tr(),
              color: _atLeastOneUpperCase
                  ? AppColors.blackColor
                  : AppColors.blackColor38,
              icon: Icon(
                Icons.check,
                color: _atLeastOneUpperCase
                    ? AppColors.blackColor
                    : AppColors.blackColor38,
              ),
              spacing: 10,
              isIconFirst: true,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomIconText(
              text: 'at_least_one_number_validation'.tr(),
              color: _atLeastOneNumber
                  ? AppColors.blackColor
                  : AppColors.blackColor38,
              icon: Icon(
                Icons.check,
                color: _atLeastOneNumber
                    ? AppColors.blackColor
                    : AppColors.blackColor38,
              ),
              spacing: 10,
              isIconFirst: true,
            ),
          ],
        ),
      ),
      floatingActionButton: _isShowContinueButton
          ? CustomButton(
              buttonText: 'continue_btn'.tr(),
              borderRadius: 15,
              horizontalMargin: 20,
              onTap: _saveForm,
              borderColor: AppColors.primaryColorOfApp,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
