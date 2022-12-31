import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/service/auth_service.dart';

import '../helper/app_light_text.dart';
import '../helper/custom_button.dart';
import '../model/user_credentials.dart';
import 'main_screen.dart';

class UserInfo extends StatefulWidget {
  static const routeName = '/user_info';
  UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _form = GlobalKey<FormState>();
  final _lastnameFocusNode = FocusNode();
  final _firstnameFocusNode = FocusNode();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  bool _isShowDoneButton = false;
  bool _isDisableDoneButton = false;

  void _checkIfNameChanged(String text) {
    if (_firstnameController.text != '' && _lastnameController.text != '') {
      setState(() {
        _isShowDoneButton = true;
      });
    } else {
      setState(() {
        _isShowDoneButton = false;
      });
    }
  }

  void _saveForm() {
    setState(() {
      _isDisableDoneButton=true;
    });
    FocusScope.of(context).unfocus();
    _form.currentState!.save();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserCredentials;

    void _redirectUserToProfileScreen() {
      setState(() {
        _isDisableDoneButton=false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            bottomNavIndex: 3,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }

    void _registerUser() async {
      if (_isShowDoneButton) {
        await AuthService().registerUser(
          context: context,
          firstName: _firstnameController.text,
          lastName: _lastnameController.text,
          email: args.email,
          password: args.password,
        );
        _redirectUserToProfileScreen();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'let\'s_get_know_app_bar_title'.tr(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  Column(
                    children: [
                      AppLightText(
                        text: 'first_name'.tr(),
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
                                .requestFocus(_firstnameFocusNode);
                          }
                        },
                        child: CustomTextFormField(
                          controller: _firstnameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          focusNode: _firstnameFocusNode,
                          onChanged: (value) => _checkIfNameChanged(value),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_lastnameFocusNode),
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
                        text: 'last_name'.tr(),
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
                        controller: _lastnameController,
                        keyboardType: TextInputType.name,
                        focusNode: _lastnameFocusNode,
                        onChanged: (value) => _checkIfNameChanged(value),
                        onFieldSubmitted: (_) => _saveForm(),
                        textInputAction: TextInputAction.done,
                        onSaved: (_) => _registerUser(),
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
              onTap: _isDisableDoneButton ? () {} : _saveForm,
              borderColor: AppColors.primaryColorOfApp,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
