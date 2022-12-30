import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/service/auth_service.dart';
import 'package:seyr/service/en_de_cryption.dart';

import '../helper/app_colors.dart';
import '../helper/constants.dart';
import '../helper/custom_button.dart';
import '../helper/custom_icon_text.dart';
import '../service/firebase_firestore_service.dart';
import 'main_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  final _resetPasswordForm = GlobalKey<FormState>();
  final _newPasswordFocusNode = FocusNode();
  final _repeatPasswordFocusNode = FocusNode();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _minimumPasswordLength = false;
  bool _atLeastOneNumber = false;
  bool _atLeastOneLowerCase = false;
  bool _atLeastOneUpperCase = false;
  bool _isShowDoneButton = false;
  bool _isObscureNewPassword = true;
  bool _isObscureRepeatPassword = true;

  @override
  void initState() {
    super.initState();
  }

  void _toggleObscureNewPassword() {
    setState(() {
      _isObscureNewPassword = !_isObscureNewPassword;
    });
  }

  void _toggleObscureRepeatPassword() {
    setState(() {
      _isObscureRepeatPassword = !_isObscureRepeatPassword;
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _checkNewPasswordValidation(String character) {
    if (_newPasswordController.text.length >= 6) {
      setState(() {
        _minimumPasswordLength = true;
      });
    } else {
      setState(() {
        _minimumPasswordLength = false;
      });
    }
    if (!RegExp(lowerCasePattern).hasMatch(_newPasswordController.text)) {
      setState(() {
        _atLeastOneLowerCase = false;
      });
    } else {
      setState(() {
        _atLeastOneLowerCase = true;
      });
    }
    if (!RegExp(upperCasePattern).hasMatch(_newPasswordController.text)) {
      setState(() {
        _atLeastOneUpperCase = false;
      });
    } else {
      setState(() {
        _atLeastOneUpperCase = true;
      });
    }
    if (!RegExp((r'\d')).hasMatch(_newPasswordController.text)) {
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
        _atLeastOneUpperCase &&
        _newPasswordController.text == _repeatPasswordController.text) {
      setState(() {
        _isShowDoneButton = true;
      });
    } else {
      setState(() {
        _isShowDoneButton = false;
      });
    }
  }

  void _checkRepeatPasswordValidation(String character) {
    if (_newPasswordController.text == _repeatPasswordController.text) {
      setState(() {
        _isShowDoneButton = true;
      });
    } else {
      setState(() {
        _isShowDoneButton = false;
      });
    }
  }

  void updateUserPassword(String newPassword, String email) async {
    if (_isShowDoneButton) {
      final String? base16Encrypted =
          await FireStoreService().getUserPasswordFromFirestore(email);
      if (base16Encrypted != null) {
        String oldPassword = EnDeCryption()
            .decryptWithAES(Encrypted.fromBase16(base16Encrypted));
        callUpdatePasswordMethod(newPassword, oldPassword, email);
      }
    }
  }

  void callUpdatePasswordMethod(
    String newPassword,
    String oldPassword,
    String email,
  ) {
    AuthService().updateUserPassword(
      context,
      newPassword,
      oldPassword,
      email,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          bottomNavIndex: 3,
        ),
      ),
    );
  }

  void saveForm() {
    FocusScope.of(context).unfocus();
    _resetPasswordForm.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'reset_password_app_title'.tr(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _resetPasswordForm,
              child: Column(
                children: [
                  Column(
                    children: [
                      AppLightText(
                        text: 'new_password_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Focus(
                        autofocus: true,
                        onFocusChange: (bool inFocus) {
                          if (inFocus) {
                            FocusScope.of(context)
                                .requestFocus(_newPasswordFocusNode);
                          }
                        },
                        child: CustomTextFormField(
                          controller: _newPasswordController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          focusNode: _newPasswordFocusNode,
                          obscureText: _isObscureNewPassword,
                          suffixIcon: GestureDetector(
                            onTap: () => _toggleObscureNewPassword(),
                            child: _isObscureNewPassword
                                ? const Icon(Icons.remove_red_eye_outlined)
                                : const Icon(Icons.remove_red_eye),
                          ),
                          onChanged: (value) =>
                              _checkNewPasswordValidation(value),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_repeatPasswordFocusNode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'repeat_password_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _repeatPasswordController,
                        focusNode: _repeatPasswordFocusNode,
                        obscureText: _isObscureRepeatPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => _toggleObscureRepeatPassword(),
                          child: _isObscureRepeatPassword
                              ? const Icon(Icons.remove_red_eye_outlined)
                              : const Icon(Icons.remove_red_eye),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) =>
                            _checkRepeatPasswordValidation(value),
                        onFieldSubmitted: (_) => saveForm(),
                        onSaved: (value) =>
                            updateUserPassword(value, args['email']),
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
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isShowDoneButton
          ? CustomButton(
              buttonText: 'done_btn'.tr(),
              borderRadius: 15,
              horizontalMargin: 20,
              verticalMargin: 5,
              onTap: () => saveForm(),
              borderColor: AppColors.primaryColorOfApp,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
