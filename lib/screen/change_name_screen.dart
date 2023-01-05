import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/service/auth_service.dart';

import '../helper/app_colors.dart';
import '../helper/custom_button.dart';
import 'main_screen.dart';

class ChangeNameScreen extends StatefulWidget {
  const ChangeNameScreen({
    required this.firstName,
    required this.lastName,
    Key? key,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  static const routeName = '/change-name';
  @override
  State<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen>
    with TickerProviderStateMixin {
  final _changeNameForm = GlobalKey<FormState>();
  final _lastnameFocusNode = FocusNode();
  final _firstnameFocusNode = FocusNode();
  TextEditingController? _firstnameController;
  TextEditingController? _lastnameController;
  bool _isShowDoneButton = false;
  bool _isDisableDoneButton = false;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.firstName);
    _lastnameController = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    _firstnameController?.dispose();
    _lastnameController?.dispose();
    super.dispose();
  }

  void _saveNameChange() {
    if (_isShowDoneButton) {
      String? changedFirstName = _firstnameController?.text;
      String? changedLastName = _lastnameController?.text;
      AuthService().updateUserName(context, changedFirstName, changedLastName);
      setState(() {
        _isDisableDoneButton = false;
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
  }

  void _checkIfNameChanged(String text) {
    if ((widget.firstName != _firstnameController?.text ||
            widget.lastName != _lastnameController?.text) &&
        (_firstnameController?.text != '' && _lastnameController?.text != '')) {
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
      _isDisableDoneButton = true;
    });
    FocusScope.of(context).unfocus();
    _changeNameForm.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'change_name_app_bar_title'.tr(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _changeNameForm,
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
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
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
                        focusNode: _lastnameFocusNode,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) => _checkIfNameChanged(value),
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (_) => _saveNameChange(),
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
