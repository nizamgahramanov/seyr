import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/screen/main_screen.dart';
import 'package:seyr/service/en_de_cryption.dart';

import '../helper/app_colors.dart';
import '../helper/custom_button.dart';
import '../helper/utility.dart';
import '../service/auth_service.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    required this.email,
    required this.password,
    Key? key,
  }) : super(key: key);
  final String email;
  final String? password;
  static const routeName = '/change-email';
  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _changeEmailForm = GlobalKey<FormState>();
  TextEditingController? _emailController;
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _isShowSaveButton = false;

  void checkIfEmailChanged(String text) {
    if (widget.email != _emailController?.text &&
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(_emailController!.text) &&
        _emailController?.text != '' &&
        _passwordController.text != '') {
      setState(() {
        _isShowSaveButton = true;
      });
    } else {
      setState(() {
        _isShowSaveButton = false;
      });
    }
  }

  void toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  void _saveForm() {
    FocusScope.of(context).unfocus();
    _changeEmailForm.currentState!.save();
  }

  void saveEmailChange() {
    if (_isShowSaveButton) {
      String? enteredEmail = _emailController?.text;
      String enteredPassword = _passwordController.text;
      bool isPasswordCorrect =
          EnDeCryption().isPasswordCorrect(enteredPassword, widget.password!);
      if (isPasswordCorrect) {
        AuthService().updateUserEmail(
          context,
          enteredEmail,
          enteredPassword,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              bottomNavIndex: 3,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Utility.getInstance().showAlertDialog(
          popButtonColor: AppColors.redAccent300,
          context: context,
          alertTitle: 'password_is_not_correct_dialog_msg'.tr(),
          alertMessage: 'please_check_and_try_again_dialog_msg'.tr(),
          popButtonText: 'ok_btn'.tr(),
          onPopTap: () => Navigator.of(context).pop(),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'change_email_app_bar_title'.tr(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _changeEmailForm,
              child: Column(
                children: [
                  Column(
                    children: [
                      AppLightText(
                        spacing: 2,
                        text: 'email_title'.tr(),
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
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          }
                        },
                        child: CustomTextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                          onChanged: (value) => checkIfEmailChanged(value),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
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
                        text: 'current_password_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        obscureText: _isObscure,
                        focusNode: _passwordFocusNode,
                        suffixIcon: GestureDetector(
                          onTap: () => toggleObscure(),
                          child: _isObscure
                              ? const Icon(Icons.remove_red_eye_outlined)
                              : const Icon(Icons.remove_red_eye),
                        ),
                        onChanged: (value) => checkIfEmailChanged(value),
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (_) => saveEmailChange(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isShowSaveButton
          ? CustomButton(
              buttonText: 'done_btn'.tr(),
              borderRadius: 15,
              horizontalMargin: 20,
              verticalMargin: 5,
              onTap: ()=>_saveForm(),
              borderColor: AppColors.primaryColorOfApp,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
